# frozen_string_literal: true

require "test_helper"

class ProgressHelperTest < ActionView::TestCase
  FakeLift = Struct.new(:points, :tone, keyword_init: true)

  test "mini variant renders an area path, a line path and the current-point dot" do
    svg = parse(progress_chart(lift, variant: :mini))

    assert_equal 1, svg.css("svg").size
    assert_equal "0 0 200 62", svg.at_css("svg")["viewBox"]
    assert_equal 2, svg.css("path").size
    assert_equal 1, svg.css("circle").size
  end

  test "chart carries its tone class and marks the current dot" do
    svg = parse(progress_chart(lift(tone: "stall"), variant: :rail))

    assert_includes svg.at_css("svg")["class"].split, "stall"
    assert_equal "currentColor", svg.css("path").last["stroke"]
    assert_equal "chart-cur", svg.at_css("circle")["class"]
    assert_equal "0 0 88 30", svg.at_css("svg")["viewBox"]
  end

  test "hero variant adds gridlines, axis labels and per-workout dots" do
    svg = parse(progress_chart(lift, variant: :hero))

    assert_equal 5, svg.css("line").size
    labels = svg.css("text").map(&:text)
    assert_includes labels, "Jun 1"
    assert_includes labels, "Jun 21"
    assert_includes labels, "20"
    # two history dots + halo + current dot
    assert_equal 4, svg.css("circle").size
  end

  test "a single-point series renders centred without NaN coordinates" do
    single = lift(points: [point(Date.new(2026, 6, 1), 30)])

    html = progress_chart(single, variant: :mini)

    assert_includes html, "<svg"
    assert_not_includes html, "NaN"
  end

  test "a flat series stays within the viewbox" do
    flat = lift(points: [point(Date.new(2026, 6, 1), 30), point(Date.new(2026, 6, 8), 30)])

    html = progress_chart(flat, variant: :mini)

    assert_not_includes html, "NaN"
    assert_not_includes html, "Infinity"
  end

  private

  def point(date, weight)
    LiftProgress::Point.new(date: date, weight: weight, reps: 8, rir: 1, sets_count: 3)
  end

  def lift(points: nil, tone: "up")
    points ||= [
      point(Date.new(2026, 6, 1), 15),
      point(Date.new(2026, 6, 10), 20),
      point(Date.new(2026, 6, 21), 17.5),
    ]
    FakeLift.new(points: points, tone: tone)
  end

  def parse(html)
    # XML parsing keeps attribute casing (viewBox) intact.
    Nokogiri::XML.fragment(html)
  end
end
