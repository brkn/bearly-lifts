# frozen_string_literal: true

require "test_helper"

class MuscleTest < ActiveSupport::TestCase
  test "gap_ranked lists never-trained muscles first, then longest-since-trained" do
    ranked = Muscle.gap_ranked(today: Date.new(2026, 6, 18))

    assert_equal %w[Shoulders Arms Back], ranked.map(&:name)
  end

  test "gap_ranked annotates each muscle with last_trained_on and days_since" do
    ranked = Muscle.gap_ranked(today: Date.new(2026, 6, 18)).index_by(&:name)

    assert_equal Date.new(2026, 5, 28), ranked["Back"].last_trained_on
    assert_equal 21, ranked["Back"].days_since

    assert_nil ranked["Shoulders"].last_trained_on
    assert_nil ranked["Shoulders"].days_since
  end

  test "a muscle is overdue once its gap exceeds the cadence, or it was never trained" do
    ranked = Muscle.gap_ranked(today: Date.new(2026, 6, 18)).index_by(&:name)

    assert_predicate ranked["Shoulders"], :overdue?
    assert_predicate ranked["Back"], :overdue?
  end
end
