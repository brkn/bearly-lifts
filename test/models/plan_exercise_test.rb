# frozen_string_literal: true

require "test_helper"

class PlanExerciseTest < ActiveSupport::TestCase
  test "delegates name to its exercise variation" do
    assert_equal exercise_variations(:bench_press_default).name, plan_exercises(:bench_press).name
  end

  test "is valid with positive integer targets and a weight" do
    assert plan_exercises(:bench_press).valid?
  end

  test "rejects a missing or non-positive target_sets" do
    plan_exercise = plan_exercises(:bench_press)

    [nil, 0, -1].each do |value|
      plan_exercise.target_sets = value

      assert plan_exercise.invalid?
    end
  end

  test "rejects a missing or non-positive target_reps" do
    plan_exercise = plan_exercises(:bench_press)

    [nil, 0, -1].each do |value|
      plan_exercise.target_reps = value

      assert plan_exercise.invalid?
    end
  end

  test "allows a nil target_weight but rejects a negative one" do
    plan_exercise = plan_exercises(:bench_press)

    plan_exercise.target_weight = nil
    assert plan_exercise.valid?

    plan_exercise.target_weight = -1
    assert plan_exercise.invalid?
  end
end
