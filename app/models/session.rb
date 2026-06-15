# frozen_string_literal: true

class Session < ApplicationRecord
  has_many :session_exercises, dependent: :destroy

  validates :rpe, presence: true,
                  numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
end
