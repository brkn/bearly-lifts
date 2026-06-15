# frozen_string_literal: true

class Session < ApplicationRecord
  has_many :session_exercises, dependent: :destroy
  has_many :muscles, through: :session_exercises

  validates :rpe, presence: true,
                  numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }

  def exercises_by_primary_muscle
    session_exercises.sort_by(&:created_at).group_by(&:primary_muscle)
  end
end
