# frozen_string_literal: true

require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @main_user = users(:one)
    @other_user = users(:two)

    sign_in_as(@main_user)
  end

  test "index responds successfully" do
    get root_path

    assert_response :success
  end

  test "index renders at most the five most recent workouts" do
    3.times { @main_user.workouts.create!(rpe: 7) }

    get root_path

    assert_select ".row", 5
  end

  test "index orders workouts newest first" do
    get root_path

    assert response.body.index("MAY 28") < response.body.index("MAY 12"),
           "expected the newer workout (MAY 28) to appear before the older workout (MAY 12)"
  end

  test "index links each workout row to its show page" do
    @other_user.workouts.create!(date: Time.zone.local(2026, 6, 1, 12), rpe: 7)

    get root_path

    workout_paths = [workouts(:may12), workouts(:may16), workouts(:may21), workouts(:may28)].map do |workout|
      workout_path(workout)
    end

    assert_select ".row", 4
    workout_paths.each { |workout_path| assert_select "a.row[href=?]", workout_path }
  end

  test "index links the History nav item to the workouts page" do
    get root_path

    assert_select "nav.nav a[href=?]", workouts_path, text: "History"
  end

  test "index links the Plan nav item to the plan page" do
    get root_path

    assert_select "nav.nav a[href=?]", edit_plan_path, text: "Plan"
  end

  test "index links the Progress nav item to the progress page" do
    get root_path

    assert_select "nav.nav a[href=?]", progress_path, text: "Progress"
  end

  test "index links the Plan a workout button to the plan page" do
    get root_path

    assert_select "a.btn.primary[href=?]", edit_plan_path
  end

  test "index shows muscles worked in recent workouts" do
    get root_path

    assert_includes response.body, "Arms"
    assert_includes response.body, "Back"
  end

  test "index footer shows total and month workout counts" do
    # Frozen so the fixtures (May 2026) never drift into the current month.
    travel_to Time.zone.local(2026, 6, 15, 12) do
      @main_user.workouts.create!(date: Time.zone.local(2026, 6, 1, 12), rpe: 7)

      get root_path

      assert_select ".foot b", "5"
      assert_select ".foot b", "1"
    end
  end
end
