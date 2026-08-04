# frozen_string_literal: true

require "test_helper"

class ProgressChartRailTest < ActiveSupport::TestCase
  FakeLift = Struct.new(:points, :tone, keyword_init: true)
  FakePoint = Struct.new(:weight, keyword_init: true)

  test "exposes the rail sparkline scalars" do
    chart = ProgressChart::Rail.new(FakeLift.new(points: [FakePoint.new(weight: 20)], tone: "up"))

    assert_equal 88, chart.width
    assert_equal 30, chart.height
    assert_equal "chart-rail", chart.css_class
    assert_in_delta(2.6, chart.dot_radius)
    assert_in_delta(1.8, chart.stroke_width)
  end
end
