# frozen_string_literal: true

class SeedDemoUsers
  def self.seed!
    password_digest = BCrypt::Password.create("devdevdev")

    User.create_with(password_digest: password_digest)
        .find_or_create_by!(email_address: "dev@example.com")
  end
end
