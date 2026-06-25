# frozen_string_literal: true

require "test_helper"

class WorkoutsControllerNewTest < ActionDispatch::IntegrationTest
  test "new renders the log-session form scaffold" do
    get new_workout_path

    assert_response :success
    assert_select "input[name='workout[workout_exercises][][exercise_variation_id]']"
    assert_select "input[name='workout[workout_exercises][][workout_exercise_sets][][reps]']"
    assert_select "input[name='workout[workout_exercises][][workout_exercise_sets][][weight]']"
    assert_select "input[name='workout[workout_exercises][][workout_exercise_sets][][rir]']"
    assert_select "button[type='submit']", /Save session/
  end

  test "new wires the form and its tree to the workout-form controller" do
    get new_workout_path

    assert_select "form[data-controller='workout-form']"
    assert_select ".tree[data-workout-form-target='tree']"
  end

  test "new provides clone templates for adding exercises and sets" do
    get new_workout_path

    assert_select "template[data-workout-form-target='exerciseTemplate']", 1
    assert_select "template[data-workout-form-target='setTemplate']", 1
  end

  test "new renders a 1 through 10 rpe radio group" do
    get new_workout_path

    assert_select "input[type=radio][name='workout[rpe]']", count: 10
    (1..10).each do |value|
      assert_select "input[type=radio][name='workout[rpe]'][value=?]", value.to_s
    end
  end

  test "new pre-selects rpe 7 by default" do
    get new_workout_path

    assert_select "input[type=radio][name='workout[rpe]'][checked]", count: 1
    assert_select "input[type=radio][name='workout[rpe]'][value='7'][checked]"
  end
end
