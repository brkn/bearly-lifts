# frozen_string_literal: true

class Workout < ApplicationRecord
  has_many :workout_exercises, dependent: :destroy
  has_many :muscles, through: :workout_exercises

  validates :rpe, presence: true,
                  numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
end
