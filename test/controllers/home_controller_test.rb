# frozen_string_literal: true

require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  # Frozen so the four May fixtures land in the 8-week cadence window as [0, 0, 2, 1, 1, 0, 0, 0].
  CADENCE_DATE = Time.zone.local(2026, 6, 17, 12)

  setup do
    @main_user = users(:one)
    @other_user = users(:two)
    @main_user_workouts = [workouts(:may12), workouts(:may16), workouts(:may21), workouts(:may28)]

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

    assert_select ".row", 4
    @main_user_workouts.each { |workout| assert_select "a.row[href=?]", workout_path(workout) }
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

  test "index cadence reads down when the last four weeks fall behind" do
    travel_to CADENCE_DATE do
      get root_path

      assert_select ".cadence .num b", "0.3"
      assert_select ".cadence .num .delta.down", "↓ from 0.5"
      assert_select ".cadence .label .diamond.down"
      assert_select ".verdict", /Showing up less/
    end
  end

  test "index cadence reads up when the last four weeks run ahead" do
    travel_to CADENCE_DATE do
      log_workouts_on(%w[2026-06-08 2026-06-09 2026-06-15 2026-06-16], user: @main_user)

      get root_path

      assert_select ".cadence .num b", "1.3"
      assert_select ".cadence .num .delta.up", "↑ from 1.0"
      assert_select ".cadence .label .diamond.up"
      assert_select ".verdict", /Showing up more/
      assert_select ".lede", /running ahead of your 8-week average/
    end
  end

  test "index cadence reads flat when the last four weeks match the average" do
    travel_to CADENCE_DATE do
      log_workouts_on(%w[2026-06-15 2026-06-16], user: @main_user)

      get root_path

      assert_select ".cadence .num b", "0.8"
      assert_select ".cadence .num .delta.flat", "steady"
      assert_select ".cadence .label .diamond.flat"
      assert_select ".verdict", /Holding steady/
    end
  end

  test "index cadence chart draws a bar per week with the last four weeks highlighted" do
    travel_to CADENCE_DATE do
      get root_path

      assert_select ".chart .bar", 8
      assert_select ".chart .bar.new", 4
    end
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
