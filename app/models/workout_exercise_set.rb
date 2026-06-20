# frozen_string_literal: true

class WorkoutExerciseSet < ApplicationRecord
  belongs_to :workout_exercise

  validates :weight, presence: true
  validates :reps, presence: true, numericality: { only_integer: true }
  validates :rir, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  def summary
    "#{reps}x#{format('%g', weight.to_f)}"
  end
end
