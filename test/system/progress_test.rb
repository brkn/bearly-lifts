# frozen_string_literal: true

require "application_system_test_case"

class ProgressTest < ApplicationSystemTestCase
  test "index page loads" do
    visit progress_path

    assert_selector "h1", text: "Progress"
  end

  test "show page loads" do
    lat = exercise_variations(:lat_pulldown_default)

    visit progress_lift_path(lat.id)

    assert_selector ".cp-name", text: lat.name
  end

  test "index lists every logged lift with badge and sparkline" do
    visit progress_path

    assert_selector ".idx-h1", text: "Progress"
    assert_selector ".feed-row", count: 15
    assert_selector ".feed-row svg.chart-mini", count: 15

    within first(".feed-row") do
      assert_selector ".fr-name"
      assert_selector ".st"
      assert_selector ".fr-rec-v"
    end
  end

  test "detail shows the rail, hero chart, stats and set history" do
    lat = exercise_variations(:lat_pulldown_default)

    visit progress_path
    find(".feed-row", text: lat.name).click

    assert_selector ".cp-name", text: lat.name
    assert_selector "svg.chart-hero", count: 1
    assert_selector ".cp-readout .r", count: 3
    assert_selector ".cp-trow.cur", count: 1
    assert_selector ".combo-rail .feed-row.sel", text: lat.name

    click_link "← All lifts"

    assert_selector ".idx-h1", text: "Progress"
  end
end
