# frozen_string_literal: true

class Muscle < ApplicationRecord
  has_many :exercise_muscles, dependent: :destroy
  has_many :exercise_variations, through: :exercise_muscles

  validates :name, presence: true
end
