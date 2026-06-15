# frozen_string_literal: true

require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  def setup
    @chest = Muscle.create!(name: "Chest")
    @back = Muscle.create!(name: "Back")

    record_session(Time.zone.local(2026, 6, 14, 12), name: "Bench Press", muscles: [@chest])
    record_session(Time.zone.local(2026, 6, 12, 12), name: "Pull Up", muscles: [@back])
    record_session(Time.zone.local(2026, 6, 10, 12), name: "Squat", muscles: [@chest])
    record_session(Time.zone.local(2026, 6, 8, 12), name: "Deadlift", muscles: [@back])
    record_session(Time.zone.local(2026, 6, 6, 12), name: "Overhead Press", muscles: [@chest])
    record_session(Time.zone.local(2026, 6, 4, 12), name: "Row", muscles: [@back])
    record_session(Time.zone.local(2026, 5, 30, 12), name: "Curl", muscles: [@chest])
  end

  test "index responds successfully" do
    get root_path

    assert_response :success
  end

  test "index renders at most the five most recent sessions" do
    get root_path

    assert_select ".row", 5
  end

  test "index orders sessions newest first" do
    get root_path

    assert response.body.index("JUN 14") < response.body.index("JUN 6"),
           "expected the newer session (JUN 14) to appear before the older session (JUN 6)"
  end

  test "index shows muscles worked in recent sessions" do
    get root_path

    assert_includes response.body, "Chest"
    assert_includes response.body, "Back"
  end

  test "index footer shows total and month session counts" do
    get root_path

    assert_select ".foot b", "7"
    assert_select ".foot b", "6"
  end

  private

  def record_session(date, name:, muscles:)
    session = Session.create!(date: date, rpe: 7)
    variation = Exercise.create!(name: name).exercise_variations.create!(name: name)
    session.session_exercises.create!(exercise_variation: variation, position: 1).muscles << muscles
  end
end
