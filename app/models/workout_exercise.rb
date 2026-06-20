# frozen_string_literal: true

class WorkoutExercise < ApplicationRecord
  belongs_to :workout
  belongs_to :exercise_variation

  has_many :workout_exercise_sets, dependent: :destroy
  has_many :muscles, through: :exercise_variation
  has_one :primary_muscle, through: :exercise_variation

  delegate :name, to: :exercise_variation
end
