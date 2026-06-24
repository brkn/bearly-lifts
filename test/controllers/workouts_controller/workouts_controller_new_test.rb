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
end
