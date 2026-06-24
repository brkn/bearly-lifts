# frozen_string_literal: true

require "test_helper"

class WorkoutExerciseTest < ActiveSupport::TestCase
  test "muscles come from the exercise variation" do
    assert_equal [muscles(:arms), muscles(:back)],
                 workout_exercises(:may28_lat_pulldown).muscles.order(:name)
  end

  test "primary_muscle comes from the exercise variation" do
    assert_equal muscles(:back), workout_exercises(:may28_lat_pulldown).primary_muscle
  end

  test "create_sets! builds a set per attributes hash" do
    workout_exercise = workout_exercises(:may28_seated_rows)

    assert_difference("WorkoutExerciseSet.count" => 2) do
      workout_exercise.create_sets!([{ reps: 10, weight: 40 }, { reps: 8, weight: 45 }])
    end
  end

  test "create_sets! treats nil as no sets" do
    workout_exercise = workout_exercises(:may28_seated_rows)

    assert_no_difference("WorkoutExerciseSet.count") do
      workout_exercise.create_sets!(nil)
    end
  end
end
