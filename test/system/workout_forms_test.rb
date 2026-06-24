# frozen_string_literal: true

require "application_system_test_case"

class WorkoutFormsTest < ApplicationSystemTestCase
  test "add and remove sets and exercises in the browser" do
    visit new_workout_path

    assert_selector ".tree .lift", count: 1
    assert_selector ".tree .sets .grid", count: 3

    click_button "+ set"
    assert_selector ".tree .sets .grid", count: 4

    first(".tree .sets .grid button.x.sm").click
    assert_selector ".tree .sets .grid", count: 3

    find(".tree .lift-head button.x").click
    assert_no_selector ".tree .lift"
  end

  test "removing a middle set renumbers the remaining set indexes" do
    visit new_workout_path

    assert_equal %w[1 2 3], all(".tree .sets .grid .idx").map(&:text)

    all(".tree .sets .grid button.x.sm")[1].click

    assert_selector ".tree .sets .grid", count: 2
    assert_equal %w[1 2], all(".tree .sets .grid .idx").map(&:text)
  end

  # TODO: system test - an invalid submit re-renders :new in place via Turbo Drive (no full reload)
  # TODO: system test - addExercise appends a populated card once the typeahead trigger lands
  # TODO: system test - a valid submit redirects to the created workout via Turbo Drive
end
