# frozen_string_literal: true

require "test_helper"

class PlansControllerTest < ActionDispatch::IntegrationTest
  test "new responds successfully and renders muscles" do
    get new_plan_path

    assert_response :success
    assert_includes response.body, muscles(:back).name
  end

  test "exercises renders a section per selected muscle" do
    post plan_exercises_path, params: { muscle_ids: [muscles(:back).id] }

    assert_response :success
    assert_select ".group", 1
    assert_includes response.body, muscles(:back).name
  end

  test "exercises renders exercise variation names" do
    post plan_exercises_path, params: { muscle_ids: [muscles(:back).id] }

    assert_includes response.body, exercise_variations(:lat_pulldown_default).name
  end

  test "review renders weight inputs for each variation" do
    lat_id = exercise_variations(:lat_pulldown_default).id

    post plan_review_path, params: { exercise_variation_ids: [lat_id] }

    assert_response :success
    assert_select "input[type=number][name=?]", "plan_exercises[#{lat_id}][target_weight]"
  end

  test "create saves a plan and redirects to show" do
    lat_id = exercise_variations(:lat_pulldown_default).id

    post plan_path, params: {
      exercise_variation_ids: [lat_id],
      plan_exercises: { lat_id => { target_sets: 3, target_reps: 10, target_weight: 37.5 } },
    }

    assert_redirected_to plan_path
    assert_equal 1, Plan.count
    assert_equal 1, Plan.current.plan_exercises.count
  end

  test "create overwrites an existing plan" do
    lat_id = exercise_variations(:lat_pulldown_default).id
    params = {
      exercise_variation_ids: [lat_id],
      plan_exercises: { lat_id => { target_sets: 3, target_reps: 10, target_weight: 37.5 } },
    }

    post plan_path, params: params
    post plan_path, params: params

    assert_equal 1, Plan.count
  end

  test "show renders the saved plan" do
    get plan_path

    assert_response :success
    assert_includes response.body, exercise_variations(:lat_pulldown_default).name
  end
end
