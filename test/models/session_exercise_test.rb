# frozen_string_literal: true

require "test_helper"

class SessionExerciseTest < ActiveSupport::TestCase
  test "primary_muscle returns the muscle flagged is_primary" do
    session_exercise = build_session_exercise

    session_exercise.exercise_muscles.create!(muscle: muscles(:arms), is_primary: false)
    session_exercise.exercise_muscles.create!(muscle: muscles(:back), is_primary: true)

    assert_equal muscles(:back), session_exercise.primary_muscle
  end

  test "primary_muscle is nil when no muscle is flagged primary" do
    session_exercise = build_session_exercise
    session_exercise.exercise_muscles.create!(muscle: muscles(:arms), is_primary: false)

    assert_nil session_exercise.primary_muscle
  end

  private

  def build_session_exercise
    sessions(:may10)
      .session_exercises
      .create!(
        exercise_variation: exercise_variations(:lat_pulldown_default),
        position: 3,
      )
  end
end
