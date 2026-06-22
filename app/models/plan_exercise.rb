# frozen_string_literal: true

class PlanExercise < ApplicationRecord
  belongs_to :plan
  belongs_to :exercise_variation

  validates :target_sets, numericality: { only_integer: true, greater_than: 0 }
  validates :target_reps, numericality: { only_integer: true, greater_than: 0 }
  validates :target_weight, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  delegate :name, to: :exercise_variation
  delegate :input_name, to: :presenter

  def presenter
    @presenter ||= PlanExercisePresenter.new(self)
  end
end
