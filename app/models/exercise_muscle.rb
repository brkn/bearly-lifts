# frozen_string_literal: true

class ExerciseMuscle < ApplicationRecord
  self.primary_key = [:session_exercise_id, :muscle_id]

  belongs_to :session_exercise
  belongs_to :muscle

  validates :is_primary, inclusion: { in: [true, false] }
end
