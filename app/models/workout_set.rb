# frozen_string_literal: true

class WorkoutSet < ApplicationRecord
  belongs_to :session_exercise

  validates :weight, presence: true
  validates :reps, presence: true, numericality: { only_integer: true }
  validates :rir, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
end
