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
end
