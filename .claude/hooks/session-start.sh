#!/usr/bin/env bash
#
# SessionStart hook for Claude Code on the web.
#
# Prepares a full dev/test environment for this Rails app:
#   * mise            -> installs & manages Ruby 3.4.7 (see mise.toml / .ruby-version)
#   * system Docker   -> runs PostgreSQL for the dev + test databases
#   * bundler         -> installs gems
#   * rails db:prepare-> creates and loads the dev + test databases
#
# Network policy note: this needs a "Custom" network access policy that adds
#   cache.ruby-lang.org          (Ruby source tarball for mise to compile)
#   production.cloudfront.docker.com  (Docker Hub image-layer CDN)
# on top of the default Trusted allowlist. Without them the Ruby compile and the
# postgres image pull will 403.
set -euo pipefail

# Only run inside Claude Code cloud/web sessions.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel)}"

log() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

# ---------------------------------------------------------------------------
# 1. mise — installed via npm (the mise.run installer host is not allowlisted,
#    but registry.npmjs.org is). Ruby is compiled from source because the
#    precompiled path downloads GitHub release assets, which the GitHub proxy
#    blocks for repos not attached to the session.
# ---------------------------------------------------------------------------
export MISE_YES=1               # assume "yes" to prompts
export MISE_VERSION_CHECK=0     # skip the self-update ping to the blocked mise CDN
export MISE_RUBY_COMPILE=1      # compile Ruby from source, don't fetch a prebuilt

if ! command -v mise >/dev/null 2>&1; then
  log "Installing mise (via npm)"
  npm install -g mise
fi

# Expose mise's shims (ruby, bundle, gem, rails, ...) for this session and persist
# them for the rest of the Claude session via CLAUDE_ENV_FILE.
MISE_DATA_DIR="${MISE_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/mise}"
SHIMS_DIR="$MISE_DATA_DIR/shims"
export PATH="$SHIMS_DIR:$PATH"
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  {
    echo "export MISE_YES=1"
    echo "export PATH=\"$SHIMS_DIR:\$PATH\""
  } >> "$CLAUDE_ENV_FILE"
fi

log "Installing Ruby toolchain with mise (compiling from source; first run is slow)"
mise install
mise reshim
ruby --version

# ---------------------------------------------------------------------------
# 2. System packages — the pg gem needs libpq headers to build its native ext.
#    (apt-get update exits non-zero on blocked third-party PPAs; the main Ubuntu
#    archive still updates, so tolerate that failure and continue.)
# ---------------------------------------------------------------------------
if [ ! -f /usr/include/postgresql/libpq-fe.h ]; then
  log "Installing libpq-dev (pg gem build dependency)"
  sudo apt-get update -qq || true
  sudo apt-get install -y -qq libpq-dev
fi

# ---------------------------------------------------------------------------
# 3. Gems
# ---------------------------------------------------------------------------
log "Installing gems (bundle install)"
gem install bundler --conservative --no-document
bundle install

# ---------------------------------------------------------------------------
# 4. PostgreSQL via the system Docker daemon (docker-compose.dev.yml)
# ---------------------------------------------------------------------------
if ! docker info >/dev/null 2>&1; then
  log "Starting Docker daemon"
  sudo service docker start || true
  for _ in $(seq 1 20); do docker info >/dev/null 2>&1 && break; sleep 1; done
fi

log "Starting PostgreSQL (docker compose up)"
docker compose -f docker-compose.dev.yml up -d

log "Waiting for PostgreSQL to accept connections"
for _ in $(seq 1 40); do
  if docker exec bearly_lift_postgres pg_isready -U postgres >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

# ---------------------------------------------------------------------------
# 5. Databases — idempotent create + schema load for development and test.
#    database.yml defaults (host=localhost, user/pass=postgres) match the
#    compose service, so no extra env vars are needed.
# ---------------------------------------------------------------------------
log "Preparing development database"
bin/rails db:prepare

log "Preparing test database"
RAILS_ENV=test bin/rails db:prepare

log "Environment ready — Ruby $(ruby -e 'print RUBY_VERSION'), Postgres up, gems installed, databases prepared."
