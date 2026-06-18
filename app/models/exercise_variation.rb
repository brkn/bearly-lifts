# frozen_string_literal: true

class ExerciseVariation < ApplicationRecord
  belongs_to :exercise

  has_many :session_exercises, dependent: :restrict_with_exception
  has_many :exercise_muscles, dependent: :destroy
  has_many :muscles, through: :exercise_muscles

  has_one :primary_exercise_muscle,
          -> { where(is_primary: true) },
          class_name: "ExerciseMuscle",
          inverse_of: :exercise_variation
  has_one :primary_muscle,
          through: :primary_exercise_muscle,
          source: :muscle

  enum :weight_scheme, {
    per_side: "per_side",
    bodyweight: "bodyweight",
    assisted: "assisted",
    machine: "machine",
  }

  validates :name, presence: true
  validates :exercise_id,
            uniqueness: { conditions: -> { where(is_default_variation: true) } },
            if: :is_default_variation
end
