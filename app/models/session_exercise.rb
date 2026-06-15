# frozen_string_literal: true

class SessionExercise < ApplicationRecord
  belongs_to :session
  belongs_to :exercise_variation

  has_many :workout_sets, dependent: :destroy
  has_many :exercise_muscles, dependent: :destroy
  has_many :muscles, through: :exercise_muscles

  has_one :primary_exercise_muscle,
          -> { where(is_primary: true) },
          class_name: "ExerciseMuscle",
          inverse_of: :session_exercise
  has_one :primary_muscle,
          through: :primary_exercise_muscle,
          source: :muscle

  delegate :name, to: :exercise_variation
end
