# frozen_string_literal: true

require "test_helper"

class SessionExerciseTest < ActiveSupport::TestCase
  test "primary_muscle returns the muscle flagged is_primary" do
    chest = Muscle.create!(name: "Chest")
    triceps = Muscle.create!(name: "Triceps")
    session_exercise = build_session_exercise

    session_exercise.exercise_muscles.create!(muscle: triceps, is_primary: false)
    session_exercise.exercise_muscles.create!(muscle: chest, is_primary: true)

    assert_equal chest, session_exercise.primary_muscle
  end

  test "primary_muscle is nil when no muscle is flagged primary" do
    session_exercise = build_session_exercise
    session_exercise.exercise_muscles.create!(muscle: Muscle.create!(name: "Chest"), is_primary: false)

    assert_nil session_exercise.primary_muscle
  end

  private

  def build_session_exercise
    session = Session.create!(date: Time.zone.local(2026, 6, 8, 12), rpe: 7)
    variation = Exercise.create!(name: "Bench Press").exercise_variations.create!(name: "Bench Press")
    session.session_exercises.create!(exercise_variation: variation)
  end
end
