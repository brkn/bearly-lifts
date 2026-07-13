# frozen_string_literal: true

require "test_helper"

class PlanTest < ActiveSupport::TestCase
  setup { @main_user = users(:one) }

  test "plan_exercises come back ordered by position" do
    assert_equal [1, 2], plans(:current).plan_exercises.map(&:position)
  end

  test "destroying a plan destroys its plan_exercises" do
    assert_difference "PlanExercise.count", -2 do
      plans(:current).destroy
    end
  end

  test "create_plan_exercises! numbers positions from 1 in the given order" do
    variations = [
      exercise_variations(:seated_cable_rows_default),
      exercise_variations(:lat_pulldown_default),
    ]

    @main_user.plan&.destroy
    plan = @main_user.create_plan!
    plan.create_plan_exercises!(variations)

    created_plan_exercise_positions = plan.plan_exercises.map { |pe| [pe.exercise_variation_id, pe.position] }
    expected_plan_positions = [[variations[0].id, 1], [variations[1].id, 2]]

    assert_equal expected_plan_positions, created_plan_exercise_positions
  end
end
