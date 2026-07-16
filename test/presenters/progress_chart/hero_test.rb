# frozen_string_literal: true

require "test_helper"

class ProgressChartHeroTest < ActiveSupport::TestCase
  FakeLift = Struct.new(:points, :tone, keyword_init: true)
  FakePoint = Struct.new(:date, :weight, keyword_init: true)

  test "grid_rows spreads five evenly spaced rows labelled max down to min" do
    rows = hero.grid_rows

    expected_ys = [22.0, 84.0, 146.0, 208.0, 270.0]
    actual_ys = rows.map(&:y)
    assert_equal expected_ys, actual_ys

    expected_labels = %w[30 25 20 15 10]
    actual_labels = rows.map(&:label)
    assert_equal expected_labels, actual_labels
  end

  test "date_labels anchors the first, middle and last points" do
    expected_labels = [
      ["Jun 1", 50.0, "start"],
      ["Jun 10", 407.0, "middle"],
      ["Jun 21", 764.0, "end"],
    ]
    actual_labels = hero.date_labels.map { |label| [label.text, label.x, label.anchor] }

    assert_equal expected_labels, actual_labels
  end

  test "history_points drops the current point" do
    expected_points = [
      ProgressChart::Point.new(x: 50.0, y: 270.0),
      ProgressChart::Point.new(x: 407.0, y: 146.0),
    ]
    actual_points = hero.history_points

    assert_equal expected_points, actual_points
  end

  private

  def hero
    points = [
      FakePoint.new(date: Date.new(2026, 6, 1), weight: 10),
      FakePoint.new(date: Date.new(2026, 6, 10), weight: 20),
      FakePoint.new(date: Date.new(2026, 6, 21), weight: 30),
    ]

    ProgressChart::Hero.new(FakeLift.new(points: points, tone: "up"))
  end
end
