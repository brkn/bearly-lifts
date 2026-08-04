# frozen_string_literal: true

require "test_helper"

class PlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @main_user = users(:one)
    @other_user = users(:two)
    sign_in_as(@main_user)
  end

  test "new responds successfully and renders muscles" do
    get new_plan_path

    assert_response :success
    assert_includes response.body, muscles(:back).name
  end

  test "new does not leak another user's training recency" do
    variation = exercise_variations(:lat_pulldown_default)
    log_workout(variation, date: Date.new(2026, 6, 17), user: @main_user)

    sign_in_as(@other_user)
    get new_plan_path

    assert_response :success
    assert_select ".meta", text: "never trained", count: 6
  end

  test "exercises renders a section per selected muscle with its exercise variations" do
    get exercises_plan_path, params: { muscles: "back" }

    assert_response :success
    assert_select ".group", 1
    assert_select ".group h2", text: "Back"
    assert_includes response.body, exercise_variations(:lat_pulldown_default).name
  end

  test "exercises renders known muscles in the submitted order and drops the rest" do
    get exercises_plan_path, params: { muscles: "legs,gills,back" }

    rendered_muscles = css_select(".group h2").map(&:text)
    expected_muscles = %w[Legs Back]

    assert_equal expected_muscles, rendered_muscles
  end

  test "exercises matches muscles regardless of case, spacing, or param shape" do
    get exercises_plan_path, params: { muscles: ["LEGS", "Posterior Chain"] }

    rendered_muscles = css_select(".group h2").map(&:text)
    expected_muscles = ["Legs", "Posterior Chain"]

    assert_equal expected_muscles, rendered_muscles
  end

  test "create saves a plan and redirects to edit" do
    lat_id = exercise_variations(:lat_pulldown_default).id

    post plan_path, params: { exercise_variation_ids: [lat_id] }

    assert_redirected_to edit_plan_path
    assert_equal 1, Plan.count
    assert_equal 1, @main_user.plan.plan_exercises.count
  end

  test "create makes a first plan for a user with no plan" do
    Plan.destroy_all
    lat_id = exercise_variations(:lat_pulldown_default).id

    post plan_path, params: { exercise_variation_ids: [lat_id] }

    assert_redirected_to edit_plan_path
    assert_equal 1, @main_user.plan.plan_exercises.count
  end

  test "create overwrites an existing plan" do
    lat_id = exercise_variations(:lat_pulldown_default).id
    row_id = exercise_variations(:seated_cable_rows_default).id

    post plan_path, params: { exercise_variation_ids: [lat_id] }
    post plan_path, params: { exercise_variation_ids: [row_id] }
    created_plan = @main_user.plan

    assert_equal 1, Plan.count
    assert_equal row_id, created_plan.plan_exercises.first.exercise_variation_id
  end

  test "create with no exercises selected saves an empty plan and redirects to edit" do
    post plan_path

    assert_redirected_to edit_plan_path
    assert_equal 1, Plan.count
    assert_equal 0, @main_user.plan.plan_exercises.count
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
    sign_in_as(@other_user)

    get edit_plan_path

    assert_redirected_to new_plan_path
  end

  test "update redirects to new when no plan exists" do
    sign_in_as(@other_user)

    patch plan_path

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
