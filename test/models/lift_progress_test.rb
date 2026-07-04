# frozen_string_literal: true

require "test_helper"

class LiftProgressTest < ActiveSupport::TestCase
  TODAY = Date.new(2026, 7, 1)

  setup { travel_to TODAY }

  test "points pick the heaviest set per workout, oldest workout first" do
    variation = create_variation
    log_workout(variation, on: Date.new(2026, 6, 20), sets: [[15, 10, 1], [17.5, 6, 0], [17.5, 8, 0]])
    log_workout(variation, on: Date.new(2026, 6, 10), sets: [[15, 8, 2]])

    points = lift_for(variation).points

    assert_equal [Date.new(2026, 6, 10), Date.new(2026, 6, 20)], points.map(&:date)
    assert_equal [15, 17.5], points.map(&:weight)
    assert_equal [8, 8], points.map(&:reps), "ties on weight resolve to the higher-rep set"
    assert_equal [1, 3], points.map(&:sets_count)
  end

  test "derives current, top, delta and idle stats from the history" do
    variation = create_variation
    log_workout(variation, on: Date.new(2026, 5, 1), sets: [[10, 8, 2]])
    log_workout(variation, on: Date.new(2026, 6, 1), sets: [[20, 8, 1]])
    log_workout(variation, on: Date.new(2026, 6, 21), sets: [[17.5, 9, 1]])

    lift = lift_for(variation)

    assert_equal 17.5, lift.current_weight
    assert_equal 9, lift.current_reps
    assert_equal 20, lift.top_weight
    assert_equal 7.5, lift.delta_weight
    assert_equal 3, lift.workouts_count
    assert_equal Date.new(2026, 5, 1), lift.first_date
    assert_equal Date.new(2026, 6, 21), lift.last_date
    assert_equal 10, lift.days_idle
  end

  test "suggestion comes from the last workout's sets" do
    variation = create_variation
    log_workout(variation, on: TODAY - 5, sets: [[40, 8, 2], [40, 7, 2]])

    suggestion = lift_for(variation).suggestion

    assert_equal :progress, suggestion.trend
    assert_equal 42.5, suggestion.weight
  end

  test "maps suggestion trends onto tones" do
    climbing = create_variation(name: "Climbing")
    log_workout(climbing, on: TODAY - 5, sets: [[40, 8, 2]])
    stalled = create_variation(name: "Stalled")
    log_workout(stalled, on: TODAY - 5, sets: [[40, 8, 0]])
    idle = create_variation(name: "Idle")
    log_workout(idle, on: TODAY - 40, sets: [[40, 8, 2]])

    assert_equal "up", lift_for(climbing).tone
    assert_equal "stall", lift_for(stalled).tone
    assert_equal "cold", lift_for(idle).tone
  end

  test "a single-workout lift has a zero delta and one point" do
    variation = create_variation
    log_workout(variation, on: TODAY - 3, sets: [[30, 10, 2]])

    lift = lift_for(variation)

    assert_equal 1, lift.workouts_count
    assert_equal 0, lift.delta_weight
  end

  test "for_all wraps only variations with logged sets" do
    logged = create_variation(name: "Logged")
    log_workout(logged, on: TODAY - 2, sets: [[30, 10, 2]])
    unlogged = create_variation(name: "Unlogged")

    ids = LiftProgress.for_all.map(&:id)

    assert_includes ids, logged.id
    assert_not_includes ids, unlogged.id
  end

  test "exposes the variation's name and primary muscle" do
    variation = exercise_variations(:lat_pulldown_default)

    lift = lift_for(variation)

    assert_equal variation.name, lift.name
    assert_equal variation.primary_muscle.name, lift.muscle_name
  end

  private

  def create_variation(name: "Test Press")
    exercise = Exercise.create!(name: name)
    exercise.exercise_variations.create!(name: "#{name} (Dumbbell)")
  end

  def log_workout(variation, on:, sets:)
    workout = users(:one).workouts.create!(date: on, rpe: 7)
    workout_exercise = workout.workout_exercises.create!(exercise_variation: variation, position: 1)
    sets.each_with_index do |(weight, reps, rir), index|
      workout_exercise.workout_exercise_sets.create!(weight:, reps:, rir:, position: index + 1)
    end
  end

  def lift_for(variation)
    LiftProgress.for_all.find { |lift| lift.id == variation.id } ||
      raise("expected #{variation.name} to appear in LiftProgress.for_all")
  end
end
