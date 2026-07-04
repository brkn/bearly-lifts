# frozen_string_literal: true

class Plan < ApplicationRecord
  has_many :plan_exercises, -> { order(:position) }, inverse_of: :plan, dependent: :destroy

  def self.current
    includes(plan_exercises: :exercise_variation).first
  end

  def create_plan_exercises!(ordered_exercise_variations)
    attributes_list = ordered_exercise_variations.each_with_index.map do |variation, index|
      {
        exercise_variation: variation,
        position: index + 1,
        target_sets: variation.suggestion.sets,
        target_reps: variation.suggestion.reps,
        target_weight: variation.suggestion.weight,
      }
    end

    plan_exercises.create!(attributes_list)
  end
end
