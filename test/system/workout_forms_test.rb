# frozen_string_literal: true

require "application_system_test_case"

class WorkoutFormsTest < ApplicationSystemTestCase
  setup { sign_in_as(users(:one)) }

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

  test "the footer tally tracks sets and exercises live" do
    visit new_workout_path
    assert_selector ".tally", text: "writes 0 sets across 0 exercises"

    add_exercise "row"
    assert_selector ".tally", text: "writes 1 sets across 1 exercises"

    click_button "+ set"
    assert_selector ".tally", text: "writes 2 sets across 1 exercises"

    add_exercise "row"
    assert_selector ".tally", text: "writes 3 sets across 2 exercises"

    first(".tree .sets .grid button.x.sm").click
    assert_selector ".tally", text: "writes 2 sets across 2 exercises"

    within first(".tree .lift-head") do
      click_button
    end
    assert_selector ".tally", text: "writes 1 sets across 1 exercises"
  end

  test "the source bar expands to a notes textarea for pasting raw notes" do
    visit new_workout_path
    assert_no_selector "textarea[name='workout[notes]']"

    find("summary", text: "Paste raw notes").click

    notes = "smith squat bar+17.5/side\nleg press 120  10 10 12"
    fill_in "workout[notes]", with: notes
    assert_field "workout[notes]", with: notes
  end

  test "the footer rpe gauge defaults to 7 and selection follows taps" do
    visit new_workout_path

    assert find("input[name='workout[rpe]'][value='7']", visible: false).checked?

    choose "workout_rpe_9", allow_label_click: true

    assert find("input[name='workout[rpe]'][value='9']", visible: false).checked?
    assert_not find("input[name='workout[rpe]'][value='7']", visible: false).checked?
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
