# frozen_string_literal: true

require "test_helper"

class SessionsTest < ActionDispatch::IntegrationTest
  test "visiting the sessions index shows a recorded session" do
    get sessions_path

    assert_response :success
    assert_select "h1", "History"
    assert_select "a[href*='/sessions/']", 2
  end
end
