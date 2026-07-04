# frozen_string_literal: true

require "test_helper"

class PlansControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "new responds successfully and renders muscles" do
    get new_plan_path

    assert_response :success
    assert_includes response.body, muscles(:back).name
  end

  test "new does not leak another user's training recency" do
    variation = exercise_variations(:lat_pulldown_default)
    other_workout = users(:one).workouts.create!(date: Date.new(2026, 6, 17), rpe: 7)
    other_workout.workout_exercises.create!(exercise_variation: variation, position: 1)

    sign_in_as(users(:two))
    get new_plan_path

    assert_response :success
    assert_select ".meta", text: "never trained", count: 6
  end

  test "exercises renders a section per selected muscle" do
    get exercises_plan_path, params: { muscle_ids: [muscles(:back).id] }

    assert_response :success
    assert_select ".group", 1
    assert_includes response.body, muscles(:back).name
  end

  test "exercises renders exercise variation names" do
    get exercises_plan_path, params: { muscle_ids: [muscles(:back).id] }

    assert_includes response.body, exercise_variations(:lat_pulldown_default).name
  end

  test "create saves a plan and redirects to edit" do
    lat_id = exercise_variations(:lat_pulldown_default).id

    post plan_path, params: { exercise_variation_ids: [lat_id] }

    assert_redirected_to edit_plan_path
    assert_equal 1, Plan.count
    assert_equal 1, Plan.current.plan_exercises.count
  end

  test "create overwrites an existing plan" do
    lat_id = exercise_variations(:lat_pulldown_default).id

    post plan_path, params: { exercise_variation_ids: [lat_id] }
    post plan_path, params: { exercise_variation_ids: [lat_id] }

    assert_equal 1, Plan.count
  end

  test "edit renders adjustable inputs for the saved plan" do
    lat_id = exercise_variations(:lat_pulldown_default).id

    get edit_plan_path

    assert_response :success
    assert_select "input[type=number][name=?][value=?]", "plan_exercises[#{lat_id}][target_sets]", "3"
  end

  test "edit redirects to new when no plan exists" do
    Plan.destroy_all

    get edit_plan_path

    assert_redirected_to new_plan_path
  end

  test "edit ignores another user's plan and redirects to new" do
    sign_in_as(users(:two))

    get edit_plan_path

    assert_redirected_to new_plan_path
  end

  test "update saves adjusted targets and redirects to edit" do
    lat_id = exercise_variations(:lat_pulldown_default).id
    row_id = exercise_variations(:seated_cable_rows_default).id

    patch plan_path, params: {
      plan_exercises: {
        lat_id => { target_sets: 5, target_reps: 8, target_weight: 40 },
        row_id => { target_sets: 4, target_reps: 12, target_weight: 50 },
      },
    }

    assert_redirected_to edit_plan_path
    assert_equal 5, plan_exercises(:lat_pulldown).reload.target_sets
  end
end
