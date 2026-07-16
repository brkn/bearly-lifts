# frozen_string_literal: true

require "test_helper"

class ProgressChartMiniTest < ActiveSupport::TestCase
  FakeLift = Struct.new(:points, :tone, keyword_init: true)
  FakePoint = Struct.new(:weight, keyword_init: true)

  test "exposes the mini sparkline scalars" do
    chart = ProgressChart::Mini.new(FakeLift.new(points: [FakePoint.new(weight: 20)], tone: "up"))

    assert_equal 200, chart.width
    assert_equal 62, chart.height
    assert_equal "chart-mini", chart.css_class
    assert_equal 3.2, chart.dot_radius
    assert_equal 2.4, chart.stroke_width
  end
end
