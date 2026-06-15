# frozen_string_literal: true

class SessionExercise < ApplicationRecord
  belongs_to :session
  belongs_to :exercise_variation, optional: true

  has_many :workout_sets, dependent: :destroy
  has_many :exercise_muscles, dependent: :destroy
  has_many :muscles, through: :exercise_muscles

  validates :name, presence: true
end
