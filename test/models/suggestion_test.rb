# frozen_string_literal: true

require "test_helper"

class SuggestionTest < ActiveSupport::TestCase
  test "holds trend, weight, sets, and reps" do
    s = Suggestion.new(trend: :progress, weight: 42.5, sets: 3, reps: 8)

    assert_equal :progress, s.trend
    assert_equal 42.5, s.weight
    assert_equal 3, s.sets
    assert_equal 8, s.reps
  end

  test "two suggestions with the same values are equal" do
    a = Suggestion.new(trend: :hold, weight: 60, sets: 3, reps: 5)
    b = Suggestion.new(trend: :hold, weight: 60, sets: 3, reps: 5)

    assert_equal a, b
  end

  test "weight and sets and reps may be nil for a rebase with no history" do
    s = Suggestion.new(trend: :rebase, weight: nil, sets: nil, reps: nil)

    assert_nil s.weight
    assert_nil s.sets
    assert_nil s.reps
  end

  test "from builds a progress suggestion when all top sets cleared with reps in reserve" do
    set = Struct.new(:weight, :reps, :rir)
    sets = [set.new(40, 8, 2), set.new(40, 7, 2)]

    s = Suggestion.from(sets, performed_on: Date.new(2026, 6, 10), today: Date.new(2026, 6, 18))

    assert_equal :progress, s.trend
    assert_equal 42.5, s.weight
    assert_equal 2, s.sets
    assert_equal 8, s.reps
  end

  test "from holds the weight when a top set hit failure" do
    set = Struct.new(:weight, :reps, :rir)

    s = Suggestion.from([set.new(60, 5, 0)], performed_on: Date.new(2026, 6, 10), today: Date.new(2026, 6, 18))

    assert_equal :hold, s.trend
    assert_equal 60, s.weight
  end

  test "from rebases when the last workout was more than 28 days ago" do
    set = Struct.new(:weight, :reps, :rir)

    s = Suggestion.from([set.new(15, 12, 3)], performed_on: Date.new(2026, 5, 1), today: Date.new(2026, 6, 18))

    assert_equal :rebase, s.trend
    assert_equal 15, s.weight
  end

  test "from uses only top-weight sets to determine trend and reps" do
    set = Struct.new(:weight, :reps, :rir)
    sets = [set.new(50, 10, 1), set.new(40, 12, 4)]

    s = Suggestion.from(sets, performed_on: Date.new(2026, 6, 10), today: Date.new(2026, 6, 18))

    assert_equal :hold, s.trend
    assert_equal 50, s.weight
    assert_equal 10, s.reps
  end
end
