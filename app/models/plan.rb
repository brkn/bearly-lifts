# frozen_string_literal: true

class Plan < ApplicationRecord
  belongs_to :user

  has_many :plan_exercises, -> { order(:position) }, inverse_of: :plan, dependent: :destroy

  def self.current
    includes(plan_exercises: :exercise_variation).first
  end

  def create_plan_exercises!(ordered_exercise_variations)
    attributes_list = ordered_exercise_variations.each_with_index.map do |variation, index|
      suggestion = variation.suggestion(user)

      {
        exercise_variation: variation,
        position: index + 1,
        target_sets: suggestion.sets,
        target_reps: suggestion.reps,
        target_weight: suggestion.weight,
      }
    end

    plan_exercises.create!(attributes_list)
  end
end
