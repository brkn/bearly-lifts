# frozen_string_literal: true

require "test_helper"

class SessionExerciseTest < ActiveSupport::TestCase
  test "muscles come from the exercise variation" do
    assert_equal [muscles(:arms), muscles(:back)],
                 session_exercises(:may10_lat_pulldown).muscles.order(:name)
  end

  test "primary_muscle comes from the exercise variation" do
    assert_equal muscles(:back), session_exercises(:may10_lat_pulldown).primary_muscle
  end
end
