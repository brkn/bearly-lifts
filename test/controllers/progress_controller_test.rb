# frozen_string_literal: true

require "test_helper"

class ProgressControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "index responds successfully with one row per logged lift" do
    get progress_index_path

    assert_response :success
    assert_select ".feed-row", 15
  end

  test "index links each row to the lift's progress page" do
    get progress_index_path

    lat = exercise_variations(:lat_pulldown_default)

    assert_select "a.feed-row[href=?]", progress_path(lat.id)
  end

  test "index renders a sparkline per row" do
    get progress_index_path

    assert_select ".feed-row svg.chart-mini", 15
  end

  test "index summarises tone counts in the header" do
    get progress_index_path

    assert_select ".idx-sum", /\d+ lifts/
  end

  test "index shows an empty state when nothing is logged" do
    Workout.destroy_all

    get progress_index_path

    assert_response :success
    assert_select ".feed-row", 0
    assert_select ".empty-state"
  end

  test "index marks the Progress nav item active" do
    get progress_index_path

    assert_select "nav.nav a.active[href=?]", progress_index_path, text: "Progress"
  end

  test "show renders the lift with hero chart, stats and set history" do
    lat = exercise_variations(:lat_pulldown_default)

    get progress_path(lat.id)

    assert_response :success
    assert_includes response.body, lat.name
    assert_select "svg.chart-hero", 1
    assert_select ".cp-trow", minimum: 2
    assert_select "a.cp-back[href=?]", progress_index_path
  end

  test "show lists all lifts in the rail and highlights the current one" do
    lat = exercise_variations(:lat_pulldown_default)

    get progress_path(lat.id)

    assert_select ".feed-row", 15
    assert_select "a.feed-row.sel[href=?]", progress_path(lat.id), 1
  end

  test "show 404s for a lift with no logged workouts" do
    exercise = Exercise.create!(name: "Ghost Press")
    variation = exercise.exercise_variations.create!(name: "Ghost Press (Barbell)")

    get progress_path(variation.id)

    assert_response :not_found
  end
end
