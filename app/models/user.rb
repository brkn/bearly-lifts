# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :workouts, dependent: :restrict_with_error
  has_many :plans, dependent: :restrict_with_error
  has_many :workout_exercises, through: :workouts

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def lift_progress = LiftProgress.for_all(self)
end
