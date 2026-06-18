# frozen_string_literal: true

require "test_helper"

class WorkoutSetTest < ActiveSupport::TestCase
  test "summary formats as reps×weight, dropping insignificant zeros" do
    assert_equal "10x30", build_set(reps: 10, weight: 30).summary
    assert_equal "12x7.5", build_set(reps: 12, weight: 7.5).summary
    assert_equal "12x27.5", build_set(reps: 12, weight: 27.5).summary
  end

  private

  def build_set(reps:, weight:)
    session_exercises(:may10_lat_pulldown)
      .workout_sets
      .create!(reps: reps, weight: weight)
  end
end
