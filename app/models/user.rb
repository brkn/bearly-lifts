# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :workouts, dependent: :restrict_with_error
  has_many :workout_exercises, through: :workouts

  has_one :plan,
          -> { includes(plan_exercises: :exercise_variation) },
          inverse_of: :user,
          dependent: :restrict_with_error

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # TODO: add password validation, min length 6
  # # TDD: add a test case for the create_password endpoint. It shall fail with an empty password.
  # # # So http request should fail: `PUT /passwords/<token> with password=""`

  def lift_progress = LiftProgress.for_all(self)

  def gap_ranked_muscles = Muscle.gap_ranked(self)
end
