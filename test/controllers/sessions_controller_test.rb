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

  test "show renders the session heading, stats, and exercises grouped by primary muscle" do
    session = build_push_session

    get session_path(session)

    assert_response :success
    assert_select "h1", /JUN 8/

    assert_includes response.body, "48 min"
    assert_includes response.body, "RPE 7"
    assert_includes response.body, "2 lifts"

    assert_select ".worked", /Chest/
    assert_select ".worked", /Side Delts/

    assert_select ".muscle-group h2", "CHEST"
    assert_select ".muscle-group h2", "SIDE DELTS"

    assert_includes response.body, "10x30 · 10x30 · 8x30 kg"
    assert_includes response.body, "12x7.5 · 12x7.5 · 12x7.5 · 12x7.5 kg"
    assert_includes response.body, "+1 rep on set 1 vs Jun 2"
  end

  test "show omits the duration badge when duration_minutes is blank" do
    session = build_push_session(duration_minutes: nil)

    get session_path(session)

    assert_response :success
    assert_select ".badge", { text: /min/, count: 0 }
  end

  private

  def record_session(date, name:, muscles:)
    session = Session.create!(date: date, rpe: 7)
    variation = Exercise.create!(name: name).exercise_variations.create!(name: name)
    session.session_exercises.create!(exercise_variation: variation, position: 1).muscles << muscles
  end

  def build_push_session(duration_minutes: 48)
    chest = Muscle.create!(name: "Chest")
    side_delts = Muscle.create!(name: "Side Delts")
    session = Session.create!(date: Time.zone.local(2026, 6, 8, 12), rpe: 7, duration_minutes: duration_minutes)

    incline = add_exercise(session, "Incline DB Press", chest, notes: "+1 rep on set 1 vs Jun 2")
    add_set(incline, reps: 10, weight: 30)
    add_set(incline, reps: 10, weight: 30)
    add_set(incline, reps: 8, weight: 30)

    lateral = add_exercise(session, "Cable Lateral Raise", side_delts)
    4.times { add_set(lateral, reps: 12, weight: 7.5) }

    session
  end

  def add_exercise(session, name, primary_muscle, notes: nil)
    variation = Exercise.create!(name: name).exercise_variations.create!(name: name)
    session_exercise = session.session_exercises.create!(exercise_variation: variation, notes: notes,
                                                         position: session.session_exercises.count + 1,)
    session_exercise.exercise_muscles.create!(muscle: primary_muscle, is_primary: true)
    session_exercise
  end

  def add_set(session_exercise, reps:, weight:)
    session_exercise.workout_sets.create!(reps: reps, weight: weight)
  end
end
