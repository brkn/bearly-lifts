# frozen_string_literal: true

require "test_helper"

class LiftProgressTest < ActiveSupport::TestCase
  TODAY = Date.new(2026, 7, 1)

  setup do
    @main_user = users(:one)
    @other_user = users(:two)

    @june10 = Date.new(2026, 6, 10)
    @june20 = Date.new(2026, 6, 20)

    @variation = create_variation(name: "hip thrust")

    travel_to TODAY
  end

  test "points pick the heaviest set per workout, oldest workout first" do
    log_workout(@variation, date: @june20, sets: [[15, 10, 1], [17.5, 6, 0], [17.5, 8, 0]], user: @main_user)
    log_workout(@variation, date: @june10, sets: [[15, 8, 2]], user: @main_user)

    points = lift_for(@variation).points

    assert_equal [@june10, @june20], points.map(&:date)
    assert_equal [15, 17.5], points.map(&:weight)
    assert_equal [8, 8], points.map(&:reps), "ties on weight resolve to the higher-rep set"
    assert_equal [1, 3], points.map(&:sets_count)
  end

  test "derives current, top, delta and idle stats from the history" do
    log_workout(@variation, date: Date.new(2026, 5, 1), sets: [[10, 8, 2]], user: @main_user)
    log_workout(@variation, date: Date.new(2026, 6, 1), sets: [[20, 8, 1]], user: @main_user)
    log_workout(@variation, date: Date.new(2026, 6, 21), sets: [[17.5, 9, 1]], user: @main_user)

    lift = lift_for(@variation)

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
    log_workout(@variation, date: TODAY - 5, sets: [[40, 8, 2], [40, 7, 2]], user: @main_user)

    suggestion = lift_for(@variation).suggestion

    assert_equal :progress, suggestion.trend
    assert_equal 42.5, suggestion.weight
  end

  test "maps suggestion trends onto tones" do
    stalled = create_variation(name: "Stalled")
    climbing = create_variation(name: "Climbing")
    idle = create_variation(name: "Idle")

    log_workout(climbing, date: TODAY - 5, sets: [[40, 8, 2]], user: @main_user)
    log_workout(stalled, date: TODAY - 5, sets: [[40, 8, 0]], user: @main_user)
    log_workout(idle, date: TODAY - 40, sets: [[40, 8, 2]], user: @main_user)

    assert_equal "up", lift_for(climbing).tone
    assert_equal "stall", lift_for(stalled).tone
    assert_equal "cold", lift_for(idle).tone
  end

  test "a single-workout lift has a zero delta and one point" do
    log_workout(@variation, date: TODAY - 3, sets: [[30, 10, 2]], user: @main_user)

    lift = lift_for(@variation)

    assert_equal 1, lift.workouts_count
    assert_equal 0, lift.delta_weight
  end

  test "for_all wraps only variations with logged sets" do
    logged = create_variation(name: "Logged")
    unlogged = create_variation(name: "Unlogged")

    log_workout(logged, date: TODAY - 2, sets: [[30, 10, 2]], user: @main_user)

    ids = LiftProgress.for_all(@main_user).map(&:id)

    assert_includes ids, logged.id
    assert_not_includes ids, unlogged.id
  end

  test "for_all excludes variations logged only by another user" do
    mine = create_variation(name: "Mine")
    theirs = create_variation(name: "Theirs")

    log_workout(mine, date: TODAY - 5, sets: [[40, 8, 2]], user: @main_user)
    log_workout(theirs, date: TODAY - 5, sets: [[50, 8, 2]], user: @other_user)

    ids = LiftProgress.for_all(@main_user).map(&:id)

    assert_includes ids, mine.id
    assert_not_includes ids, theirs.id
  end

  test "for_all reflects only the given user's sets for a shared variation" do
    shared = create_variation(name: "Shared")
    log_workout(shared, date: TODAY - 5, sets: [[40, 8, 2]], user: @main_user)
    log_workout(shared, date: TODAY - 2, sets: [[100, 8, 2]], user: @other_user)

    lift = LiftProgress.for_all(@main_user).find { |candidate| candidate.id == shared.id }

    assert_equal [40], lift.points.map(&:weight)
    assert_equal 1, lift.workouts_count
  end

  test "exposes the variation's name and primary muscle" do
    variation = exercise_variations(:lat_pulldown_default)

    lift = lift_for(variation)

    assert_equal variation.name, lift.name
    assert_equal variation.primary_muscle.name, lift.muscle_name
  end

  private

  def create_variation(name: "Test Press")
    Exercise.create!(name: name).exercise_variations.create!(name: "#{name} (Dumbbell)")
  end

  def lift_for(variation)
    LiftProgress.for_all(@main_user).find { |lift| lift.id == variation.id }
  end
end
