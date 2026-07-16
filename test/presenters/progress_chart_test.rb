# frozen_string_literal: true

require "test_helper"

class ProgressChartTest < ActiveSupport::TestCase
  FakeLift = Struct.new(:points, :tone, keyword_init: true)
  FakePoint = Struct.new(:weight, keyword_init: true)

  test "current_point is the newest coordinate rounded to one decimal" do
    points = [10, 30, 17.5].map { |weight| FakePoint.new(weight: weight) }
    chart = ProgressChart.for(:mini).new(FakeLift.new(points: points, tone: "up"))

    assert_equal ProgressChart::Point.new(x: 196.0, y: 36.8), chart.current_point
  end
end
