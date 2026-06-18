# frozen_string_literal: true

require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "index responds successfully under the RECENT heading" do
    get sessions_path

    assert_response :success
    assert_select "h1", "History"
  end

  test "index lists one row per session, newest first, with dates and muscles" do
    get sessions_path

    assert_select "a[href*='/sessions/']", 2

    assert_includes response.body, "MAY 10"
    assert_includes response.body, "MAY 28"

    assert_includes response.body, "Arms"
    assert_includes response.body, "Back"

    assert response.body.index("MAY 28") < response.body.index("MAY 10"),
           "expected the newer session (MAY 28) to appear before the older session (MAY 10)"
  end

  test "show renders the session header, stats, worked muscles, and exercises in position order" do
    get session_path(sessions(:may28))

    assert_response :success
    assert_select ".greeting .when", /MAY 28/

    assert_select ".stats", /35 min/
    assert_select ".stats", /RPE 7/
    assert_select ".stats", /2 lifts/

    assert_select ".worked", /Arms/
    assert_select ".worked", /Back/

    assert_includes response.body, "12x27.5 · 12x27.5 kg"
    assert_includes response.body, "12x35 · 12x37.5 kg"
    assert_includes response.body, "Second straight 3×12 at 27.5kg"

    assert_select ".muscle-group", false

    assert response.body.index("Tricep Overhead Cable Extension") < response.body.index("Lat Pulldown (Close V-Grip)"),
           "expected exercises to render in position order"
  end

  test "show omits the duration from the stats line when duration_minutes is blank" do
    sessions(:may28).update!(duration_minutes: nil)

    get session_path(sessions(:may28))

    assert_response :success
    assert_select ".stats", { text: /min/, count: 0 }
  end
end
