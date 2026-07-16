# frozen_string_literal: true

require "test_helper"

class CadenceTest < ActiveSupport::TestCase
  # Frozen far past the May 2026 fixtures so they sit outside the 8-week window.
  # Window week starts (Mondays): 2026-07-27 … 2026-09-14.
  FROZEN_NOW = Time.zone.local(2026, 9, 16, 12)

  setup do
    @main_user = users(:one)

    travel_to FROZEN_NOW
  end

  test "weekly_counts buckets workouts by week, oldest first, filling empty weeks with zero" do
    cadence = cadence_for(%w[2026-07-27 2026-08-10 2026-08-14 2026-09-14])

    assert_equal [1, 0, 2, 0, 0, 0, 0, 1], cadence.weekly_counts
  end

  test "weekly_counts excludes workouts older than the window" do
    cadence = cadence_for(%w[2026-07-26 2026-08-10])

    assert_equal [0, 0, 1, 0, 0, 0, 0, 0], cadence.weekly_counts
  end

  test "average rounds the eight-week mean to one decimal" do
    cadence = cadence_for(%w[2026-07-27 2026-08-10 2026-08-14 2026-08-24 2026-09-14])

    assert_equal 0.6, cadence.average
  end

  test "recent_average rounds the mean of the last four weeks to one decimal" do
    cadence = cadence_for(%w[2026-07-27 2026-08-10 2026-08-14 2026-08-24 2026-09-14])

    assert_equal 0.5, cadence.recent_average
  end

  test "trend is up when the last four weeks beat the eight-week average" do
    cadence = cadence_for(%w[2026-08-10 2026-08-24 2026-08-25 2026-08-31 2026-09-07 2026-09-08
                             2026-09-14 2026-09-15])

    assert_equal :up, cadence.trend
  end

  test "trend is down when the last four weeks fall behind the eight-week average" do
    cadence = cadence_for(%w[2026-07-27 2026-07-28 2026-08-03 2026-08-04 2026-08-10 2026-08-17
                             2026-08-18 2026-08-31])

    assert_equal :down, cadence.trend
  end

  test "trend is flat when the last four weeks match the eight-week average" do
    cadence = cadence_for(%w[2026-07-27 2026-07-28 2026-08-03 2026-08-10 2026-08-24 2026-08-31
                             2026-09-07 2026-09-14])

    assert_equal :flat, cadence.trend
  end

  test "empty history counts zero workouts every week" do
    assert_equal [0, 0, 0, 0, 0, 0, 0, 0], cadence_for([]).weekly_counts
  end

  test "empty history averages zero and reads flat" do
    cadence = cadence_for([])

    assert_equal 0.0, cadence.average
    assert_equal 0.0, cadence.recent_average
    assert_equal :flat, cadence.trend
  end

  private

  def cadence_for(days)
    log_workouts_on(days, user: @main_user)

    Cadence.new(@main_user.workouts)
  end
end
