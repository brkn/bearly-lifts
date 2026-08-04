# frozen_string_literal: true

require "test_helper"

class CadencePresenterTest < ActiveSupport::TestCase
  FakeCadence = Struct.new(:trend, :weekly_counts, :average, :recent_average, keyword_init: true)

  test "verdict summarises the trend over the last month" do
    assert_equal "Showing up more over the last month", presenter(trend: :up).verdict
    assert_equal "Showing up less over the last month", presenter(trend: :down).verdict
    assert_equal "Holding steady over the last month", presenter(trend: :flat).verdict
  end

  test "lede compares the last four weeks to the eight-week average" do
    assert_equal "Your last 4 weeks are running ahead of your 8-week average.", presenter(trend: :up).lede
    assert_equal "Your last 4 weeks are running behind your 8-week average.", presenter(trend: :down).lede
    assert_equal "Your last 4 weeks match your 8-week average.", presenter(trend: :flat).lede
  end

  test "delta names the eight-week average it moved from" do
    assert_equal "↑ from 2.1", presenter(trend: :up, average: 2.1).delta
    assert_equal "↓ from 2.1", presenter(trend: :down, average: 2.1).delta
    assert_equal "steady", presenter(trend: :flat, average: 2.1).delta
  end

  test "weeks marks only the last four as recent" do
    expected_recents = [false, false, false, false, true, true, true, true]
    actual_recents = presenter.weeks.map(&:recent)

    assert_equal expected_recents, actual_recents
  end

  test "weeks scales each height against the busiest week, rounded to one decimal" do
    expected_heights = [33.3, 0.0, 100.0, 0.0, 0.0, 66.7, 0.0, 33.3]
    actual_heights = presenter.weeks.map(&:height)

    assert_equal expected_heights, actual_heights
  end

  test "weeks heights stay zero instead of dividing by zero when every week is empty" do
    expected_heights = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    actual_heights = presenter(weekly_counts: [0, 0, 0, 0, 0, 0, 0, 0]).weeks.map(&:height)

    assert_equal expected_heights, actual_heights
  end

  test "average line heights scale against the busiest week" do
    cadence_presenter = presenter(average: 1.0, recent_average: 0.8)

    assert_in_delta(33.3, cadence_presenter.height_for_average)
    assert_in_delta(26.7, cadence_presenter.height_for_recent_average)
  end

  private

  def presenter(trend: :up, weekly_counts: [1, 0, 3, 0, 0, 2, 0, 1], average: 1.0, recent_average: 1.3)
    cadence = FakeCadence.new(
      trend: trend, weekly_counts: weekly_counts, average: average, recent_average: recent_average,
    )

    CadencePresenter.new(cadence)
  end
end
