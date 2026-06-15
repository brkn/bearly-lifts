# frozen_string_literal: true

require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    chest = Muscle.create!(name: "Chest")
    triceps = Muscle.create!(name: "Triceps")
    back = Muscle.create!(name: "Back")

    record_session(Time.zone.local(2026, 6, 8, 12), name: "Bench Press", muscles: [chest, triceps])
    record_session(Time.zone.local(2026, 6, 12, 12), name: "Pull Up", muscles: [back])
  end

  test "index responds successfully under the RECENT heading" do
    get sessions_path

    assert_response :success
    assert_select "h1", "RECENT"
  end

  test "index lists one row per session, newest first, with dates and muscles" do
    get sessions_path

    assert_select ".session", 2

    assert_includes response.body, "JUN 8"
    assert_includes response.body, "JUN 12"

    assert_includes response.body, "Chest"
    assert_includes response.body, "Triceps"
    assert_includes response.body, "Back"

    assert response.body.index("JUN 12") < response.body.index("JUN 8"),
           "expected the newer session (JUN 12) to appear before the older session (JUN 8)"
  end

  private

  def record_session(date, name:, muscles:)
    session = Session.create!(date: date, rpe: 7)
    variation = Exercise.create!(name: name).exercise_variations.create!(name: name)
    session.session_exercises.create!(exercise_variation: variation).muscles << muscles
  end
end
