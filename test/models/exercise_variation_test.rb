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
end
