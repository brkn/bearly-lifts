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
end
