# frozen_string_literal: true

require "test_helper"

class WorkoutsTest < ActionDispatch::IntegrationTest
  test "visiting the workouts index shows a recorded workout" do
    get workouts_path

    assert_response :success
    assert_select "h1", "History"
    assert_select "a[href*='/workouts/']", 4
  end
end
