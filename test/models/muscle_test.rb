# frozen_string_literal: true

require "test_helper"

class MuscleTest < ActiveSupport::TestCase
  test "gap_ranked lists muscles by longest-since-trained first" do
    ranked = Muscle.gap_ranked(today: Date.new(2026, 6, 18))

    assert_equal ["Legs", "Posterior Chain", "Chest", "Arms", "Back", "Shoulders"],
                 ranked.map(&:name)
  end

  test "gap_ranked annotates each muscle with last_trained_on and days_since" do
    ranked = Muscle.gap_ranked(today: Date.new(2026, 6, 18)).index_by(&:name)

    assert_equal Date.new(2026, 5, 28), ranked["Back"].last_trained_on
    assert_equal 21, ranked["Back"].days_since

    assert_equal Date.new(2026, 5, 12), ranked["Legs"].last_trained_on
    assert_equal 37, ranked["Legs"].days_since
  end

  test "a muscle is overdue once its gap exceeds the cadence, or it was never trained" do
    ranked = Muscle.gap_ranked(today: Date.new(2026, 6, 18)).index_by(&:name)

    assert ranked["Back"].overdue?

    never_trained = Muscle.new
    never_trained.record_gap(nil, Date.new(2026, 6, 18))

    assert never_trained.overdue?
  end
end
