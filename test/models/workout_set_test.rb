# frozen_string_literal: true

require "test_helper"

class WorkoutSetTest < ActiveSupport::TestCase
  test "summary formats as reps×weight, dropping insignificant zeros" do
    assert_equal "10x30", build_set(reps: 10, weight: 30).summary
    assert_equal "12x7.5", build_set(reps: 12, weight: 7.5).summary
    assert_equal "12x27.5", build_set(reps: 12, weight: 27.5).summary
  end

  private

  def build_set(reps:, weight:)
    session = Session.create!(date: Time.zone.local(2026, 6, 8, 12), rpe: 7)
    variation = Exercise.create!(name: "Incline DB Press").exercise_variations.create!(name: "Incline DB Press")
    session_exercise = session.session_exercises.create!(exercise_variation: variation)
    session_exercise.workout_sets.create!(reps: reps, weight: weight)
  end
end
