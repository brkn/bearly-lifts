# frozen_string_literal: true

require "test_helper"

class ExerciseVariationTest < ActiveSupport::TestCase
  test "muscles returns the muscles the variation trains" do
    assert_equal [muscles(:arms), muscles(:back)],
                 exercise_variations(:lat_pulldown_default).muscles.order(:name)
  end

  test "primary_muscle returns the muscle flagged is_primary" do
    assert_equal muscles(:back), exercise_variations(:lat_pulldown_default).primary_muscle
  end

  test "primary_muscle is nil when no muscle is flagged primary" do
    variation = exercise_variations(:curl_default)
    variation.exercise_muscles.create!(muscle: muscles(:arms), is_primary: false)

    assert_nil variation.primary_muscle
  end

  test "suggestion recommends +2.5kg when the last top sets were cleared with reps in reserve" do
    variation = exercise_variations(:bench_press_default)
    workout = Workout.create!(date: Date.new(2026, 6, 10), rpe: 7)
    workout_exercise = workout.workout_exercises.create!(exercise_variation: variation, position: 1)
    workout_exercise.workout_exercise_sets.create!(weight: 40, reps: 8, rir: 2)
    workout_exercise.workout_exercise_sets.create!(weight: 40, reps: 8, rir: 2)
    workout_exercise.workout_exercise_sets.create!(weight: 40, reps: 7, rir: 2)

    suggestion = variation.suggestion(today: Date.new(2026, 6, 18))

    assert_equal :progress, suggestion.trend
    assert_equal 42.5, suggestion.weight
    assert_equal 3, suggestion.sets
    assert_equal 8, suggestion.reps
  end

  test "suggestion holds the weight when the last top set hit failure" do
    variation = exercise_variations(:squat_default)
    workout = Workout.create!(date: Date.new(2026, 6, 10), rpe: 7)
    workout_exercise = workout.workout_exercises.create!(exercise_variation: variation, position: 1)
    workout_exercise.workout_exercise_sets.create!(weight: 60, reps: 5, rir: 0)

    suggestion = variation.suggestion(today: Date.new(2026, 6, 18))

    assert_equal :hold, suggestion.trend
    assert_equal 60, suggestion.weight
  end

  test "suggestion re-bases when the exercise is stale" do
    variation = exercise_variations(:curl_default)
    workout = Workout.create!(date: Date.new(2026, 5, 1), rpe: 7)
    workout_exercise = workout.workout_exercises.create!(exercise_variation: variation, position: 1)
    workout_exercise.workout_exercise_sets.create!(weight: 15, reps: 12, rir: 3)

    suggestion = variation.suggestion(today: Date.new(2026, 6, 18))

    assert_equal :rebase, suggestion.trend
    assert_equal 15, suggestion.weight
  end

  test "is invalid when a second default variation is added for the same exercise" do
    duplicate = ExerciseVariation.new(
      exercise: exercises(:bench_press),
      name: "Incline Bench Press",
      is_default_variation: true,
    )

    assert duplicate.invalid?
  end

  test "suggestion re-bases with no target weight when the exercise has no history" do
    suggestion = exercise_variations(:overhead_press_default).suggestion

    assert_equal :rebase, suggestion.trend
    assert_nil suggestion.weight
  end
end
