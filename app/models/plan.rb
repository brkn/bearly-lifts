# frozen_string_literal: true

class Plan < ApplicationRecord
  has_many :plan_exercises, -> { order(:position) }, inverse_of: :plan, dependent: :destroy

  def self.current
    includes(plan_exercises: :exercise_variation).first
  end
end
