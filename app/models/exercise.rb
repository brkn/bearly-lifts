# frozen_string_literal: true

class Exercise < ApplicationRecord
  has_many :exercise_variations, dependent: :destroy

  validates :name, presence: true
end
