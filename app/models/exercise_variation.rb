# frozen_string_literal: true

class ExerciseVariation < ApplicationRecord
  belongs_to :exercise

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
