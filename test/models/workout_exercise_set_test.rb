# frozen_string_literal: true

require "test_helper"

class WorkoutExerciseSetTest < ActiveSupport::TestCase
  test "summary formats as reps×weight, dropping insignificant zeros" do
    we = workout_exercises(:may28_lat_pulldown)

    assert_equal "10x30",   we.workout_exercise_sets.create!(reps: 10, weight: 30).summary
    assert_equal "12x7.5",  we.workout_exercise_sets.create!(reps: 12, weight: 7.5).summary
    assert_equal "12x27.5", we.workout_exercise_sets.create!(reps: 12, weight: 27.5).summary
  end
end
