# Bearly Lifts

A Rails app that logs workouts, shows progress per lift, ranks the muscles you have neglected longest, and suggests the next weight.

<p>
  <img src="docs/screenshots/plan-muscles.png" width="32%" alt="Plan wizard: overdue muscles">
  <img src="docs/screenshots/plan-exercises.png" width="32%" alt="Plan wizard: suggested exercises and weights">
  <img src="docs/screenshots/progress-detail.png" width="32%" alt="Progress for a single lift">
</p>

## Run

```
docker compose -f docker-compose.dev.yml up -d
bin/setup
bin/rails db:seed
```

Log in with `dev@example.com` / `devdevdev`.

## Test

```
bin/ci
bin/rails test:system
```
