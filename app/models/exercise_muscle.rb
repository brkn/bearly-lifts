# frozen_string_literal: true

class ExerciseMuscle < ApplicationRecord
  belongs_to :exercise_variation
  belongs_to :muscle

  validates :is_primary, inclusion: { in: [true, false] }
end
