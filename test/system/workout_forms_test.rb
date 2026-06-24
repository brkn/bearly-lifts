# frozen_string_literal: true

require "application_system_test_case"

class WorkoutFormsTest < ApplicationSystemTestCase
  test "selecting a typeahead result appends a populated exercise card" do
    visit new_workout_path

    assert_no_selector ".tree .lift"

    find("[data-workout-form-target='query']").set("row")
    assert_selector ".picker .results .result", text: "Seated Cable Rows"
    first(".picker .results .result").click

    assert_selector ".tree .lift", count: 1
    within ".tree .lift" do
      assert_selector ".lift-name", text: "Seated Cable Rows"
      assert_selector ".tag", text: "Back"
      assert_selector ".scheme", text: "MACHINE"
    end

    assert_equal exercise_variations(:seated_cable_rows_default).id,
                 find("input[name='workout[workout_exercises][][exercise_variation_id]']", visible: false).value
  end

  test "pressing enter after picking a result does not duplicate the exercise" do
    visit new_workout_path
    add_exercise "row"

    assert_selector ".tree .lift", count: 1

    find("[data-workout-form-target='query']").send_keys(:return)

    assert_selector ".tree .lift", count: 1
  end

  test "add and remove sets and exercises in the browser" do
    visit new_workout_path
    assert_no_selector ".tree .lift"

    add_exercise "row"

    assert_selector ".tree .lift", count: 1
    assert_selector ".tree .sets .grid", count: 1

    click_button "+ set"
    assert_selector ".tree .sets .grid", count: 2

    first(".tree .sets .grid button.x.sm").click
    assert_selector ".tree .sets .grid", count: 1

    within ".tree .lift-head" do
      click_button
    end
    assert_no_selector ".tree .lift"
  end

  test "removing a middle set renumbers the remaining set indexes" do
    visit new_workout_path
    add_exercise "row"

    click_button "+ set"
    click_button "+ set"
    assert_equal %w[1 2 3], all(".tree .sets .grid .idx").map(&:text)

    all(".tree .sets .grid button.x.sm")[1].click

    assert_selector ".tree .sets .grid", count: 2
    assert_equal %w[1 2], all(".tree .sets .grid .idx").map(&:text)
  end

  # TODO: system test - an invalid submit re-renders :new in place via Turbo Drive (no full reload)
  # TODO: system test - a valid submit redirects to the created workout via Turbo Drive

  private

  def add_exercise(query)
    find("[data-workout-form-target='query']").set(query)
    assert_selector ".picker .results .result"
    first(".picker .results .result").click
  end
end
