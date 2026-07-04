# frozen_string_literal: true

require "test_helper"

class MuscleTest < ActiveSupport::TestCase
  setup do
    @main_user = users(:one)
    @other_user = users(:two)
  end

  test "gap_ranked lists muscles by longest-since-trained first" do
    ranked = Muscle.gap_ranked(@main_user, today: Date.new(2026, 6, 18))

    assert_equal ["Legs", "Posterior Chain", "Chest", "Arms", "Back", "Shoulders"],
                 ranked.map(&:name)
  end

  test "gap_ranked annotates each muscle with last_trained_on and days_since" do
    ranked = Muscle.gap_ranked(@main_user, today: Date.new(2026, 6, 18)).index_by(&:name)

    assert_equal Date.new(2026, 5, 28), ranked["Back"].last_trained_on
    assert_equal 21, ranked["Back"].days_since

    assert_equal Date.new(2026, 5, 12), ranked["Legs"].last_trained_on
    assert_equal 37, ranked["Legs"].days_since
  end

  test "a muscle is overdue once its gap exceeds the cadence, or it was never trained" do
    ranked = Muscle.gap_ranked(@main_user, today: Date.new(2026, 6, 18)).index_by(&:name)

    assert ranked["Back"].overdue?

    never_trained = Muscle.new
    never_trained.record_gap(nil, Date.new(2026, 6, 18))

    assert never_trained.overdue?
  end

  test "gap_ranked only counts the given user's workouts" do
    variation = exercise_variations(:lat_pulldown_default)
    main_workout = @main_user.workouts.create!(date: Date.new(2026, 6, 17), rpe: 7)
    main_workout.workout_exercises.create!(exercise_variation: variation, position: 1)

    ranked = Muscle.gap_ranked(@other_user, today: Date.new(2026, 6, 18))
    last_trained_dates = ranked.map(&:last_trained_on)

    assert_not_includes last_trained_dates, main_workout.date
  end
end
