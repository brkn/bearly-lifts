# frozen_string_literal: true

class Muscle < ApplicationRecord
  validates :name, presence: true
end
