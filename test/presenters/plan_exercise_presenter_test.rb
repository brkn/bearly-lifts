# frozen_string_literal: true

require "test_helper"

class PlanExercisePresenterTest < ActiveSupport::TestCase
  test "input_name builds the nested form name for a target field" do
    plan_exercise = plan_exercises(:lat_pulldown)
    expected = "plan_exercises[#{plan_exercise.exercise_variation_id}][target_sets]"

    assert_equal expected, PlanExercisePresenter.new(plan_exercise).input_name(:target_sets)
  end
end
