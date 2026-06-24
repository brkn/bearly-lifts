# frozen_string_literal: true

class WorkoutExercise < ApplicationRecord
  belongs_to :workout
  belongs_to :exercise_variation

  has_many :workout_exercise_sets, dependent: :destroy
  has_many :muscles, through: :exercise_variation
  has_one :primary_muscle, through: :exercise_variation

  delegate :name, to: :exercise_variation

  normalizes :notes, with: ->(notes) { notes.presence }

  def create_sets!(sets)
    attributes_list = Array(sets).each_with_index.map do |set_attrs, index|
      set_attrs.slice(:reps, :weight, :rir, :notes)
               .merge(position: index + 1)
    end

    workout_exercise_sets.create!(attributes_list)
  end
end
