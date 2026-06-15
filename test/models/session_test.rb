# frozen_string_literal: true

require "test_helper"

class SessionTest < ActiveSupport::TestCase
  test "exercises_by_primary_muscle groups exercises under their primary muscle, in log order" do
    chest = Muscle.create!(name: "Chest")
    triceps = Muscle.create!(name: "Triceps")
    session = Session.create!(date: Time.zone.local(2026, 6, 8, 12), rpe: 7)

    incline = add_exercise(session, "Incline DB Press", chest)
    pec_deck = add_exercise(session, "Pec Deck", chest)
    pushdown = add_exercise(session, "Overhead Cable Extension", triceps)

    grouped = session.exercises_by_primary_muscle

    assert_equal [chest, triceps], grouped.keys
    assert_equal [incline, pec_deck], grouped[chest]
    assert_equal [pushdown], grouped[triceps]
  end

  private

  def add_exercise(session, name, primary_muscle)
    variation = Exercise.create!(name: name).exercise_variations.create!(name: name)
    session_exercise = session.session_exercises.create!(exercise_variation: variation,
                                                         position: session.session_exercises.count + 1,)
    session_exercise.exercise_muscles.create!(muscle: primary_muscle, is_primary: true)
    session_exercise
  end
end
