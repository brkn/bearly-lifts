# frozen_string_literal: true

require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "index responds successfully" do
    get root_path

    assert_response :success
  end

  test "index renders at most the five most recent sessions" do
    3.times { Session.create!(rpe: 7) }

    get root_path

    assert_select ".row", 5
  end

  test "index orders sessions newest first" do
    get root_path

    assert response.body.index("MAY 28") < response.body.index("MAY 10"),
           "expected the newer session (MAY 28) to appear before the older session (MAY 10)"
  end

  test "index links each session row to its show page" do
    3.times { Session.create!(rpe: 7) }

    get root_path

    session_ids = Session.order(date: :desc).limit(5).pluck(:id)
    session_ids.each { |id| assert_select "a.row[href=?]", session_path(id) }
  end

  test "index links the History nav item to the sessions page" do
    get root_path

    assert_select "nav.nav a[href=?]", sessions_path, text: "History"
  end

  test "index links the Today nav item to the plan page" do
    get root_path

    assert_select "nav.nav a[href=?]", new_plan_path, text: "Today"
  end

  test "index links the Plan a session button to the plan page" do
    get root_path

    assert_select "a.btn.primary[href=?]", new_plan_path
  end

  test "index shows muscles worked in recent sessions" do
    get root_path

    assert_includes response.body, "Arms"
    assert_includes response.body, "Back"
  end

  test "index footer shows total and month session counts" do
    Session.create!(date: Time.zone.local(2026, 6, 1, 12), rpe: 7)

    get root_path

    assert_select ".foot b", "3"
    assert_select ".foot b", "1"
  end
end
