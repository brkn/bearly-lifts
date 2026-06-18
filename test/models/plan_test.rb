# frozen_string_literal: true

require "test_helper"

class PlanTest < ActiveSupport::TestCase
  test "current returns the singleton plan" do
    assert_equal plans(:current), Plan.current
  end

  test "current is nil when no plan exists" do
    Plan.destroy_all

    assert_nil Plan.current
  end

  test "plan_exercises come back ordered by position" do
    assert_equal [1, 2], plans(:current).plan_exercises.map(&:position)
  end

  test "destroying a plan destroys its plan_exercises" do
    assert_difference "PlanExercise.count", -2 do
      plans(:current).destroy
    end
  end
end
