# frozen_string_literal: true

require "test_helper"

class ProgressChartGeometryTest < ActiveSupport::TestCase
  FakePoint = Struct.new(:weight, keyword_init: true)

  DIMS = { width: 100, height: 50, pad_x: 10, pad_top: 5, pad_bottom: 5 }.freeze

  test "range spans min to max weight" do
    assert_in_delta(20.0, geometry.range)
  end

  test "range is 1.0 when every weight is the same" do
    assert_in_delta(1.0, geometry(weights: [25, 25]).range)
  end

  test "x_at spreads points evenly across the inner width" do
    assert_in_delta(10.0, geometry.x_at(0))
    assert_in_delta(50.0, geometry.x_at(1))
    assert_in_delta(90.0, geometry.x_at(2))
  end

  test "x_at centres a single point" do
    assert_in_delta(50.0, geometry(weights: [20]).x_at(0))
  end

  test "line_path moves to the first point then draws lines" do
    assert_equal "M10.0 45.0 L50.0 25.0 L90.0 5.0", geometry.line_path
  end

  test "y_at maps min weight to the bottom and max to the top" do
    assert_in_delta(45.0, geometry.y_at(10.0))
    assert_in_delta(25.0, geometry.y_at(20.0))
    assert_in_delta(5.0, geometry.y_at(30.0))
  end

  private

  def geometry(weights: [10, 20, 30])
    points = weights.map { |weight| FakePoint.new(weight: weight) }

    ProgressChart::Geometry.new(points, DIMS)
  end
end
