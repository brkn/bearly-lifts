# frozen_string_literal: true

require "test_helper"

class SessionsTest < ActionDispatch::IntegrationTest
  test "visiting the sessions index shows a recorded session" do
    Session.create!(date: Time.zone.local(2026, 6, 8, 12), rpe: 7)

    get sessions_path

    assert_response :success
    assert_select "h1", "RECENT"
    assert_select ".session", 3
  end
end
