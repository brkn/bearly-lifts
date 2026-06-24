# frozen_string_literal: true

class WorkoutExercise < ApplicationRecord
  belongs_to :workout
  belongs_to :exercise_variation

  has_many :workout_exercise_sets, dependent: :destroy
  has_many :muscles, through: :exercise_variation
  has_one :primary_muscle, through: :exercise_variation

  delegate :name, to: :exercise_variation

  normalizes :notes, with: ->(notes) { notes.presence }

  # TODO: iterate with index, and add positon attr after the migration
  # ... So replace with sets.each do |set_attrs, index|
  def create_sets!(sets)
    Array(sets).each do |set_attrs|
      workout_exercise_sets.create!(
        set_attrs.slice(:reps, :weight, :rir, :notes),
      )
    end
  end
end
