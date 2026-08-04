# frozen_string_literal: true

require "test_helper"

class MuscleTest < ActiveSupport::TestCase
  setup do
    @main_user = users(:one)
    @other_user = users(:two)

    @today = Date.new(2026, 6, 18)
  end

  test "name is stored squished and lowercase" do
    muscle = Muscle.create!(name: "  Posterior  DELTS ")

    assert_equal "posterior delts", muscle.name
  end

  test "muscles are found whatever case the name is given in" do
    assert_equal muscles(:back), Muscle.find_by(name: "BACK")
  end

  test "label restores the display casing of a stored name" do
    assert_equal "Posterior Chain", muscles(:posterior_chain).label
  end

  test "gap_ranked lists muscles by longest-since-trained first" do
    ranked = Muscle.gap_ranked(@main_user, today: @today)

    assert_equal ["legs", "posterior chain", "chest", "arms", "back", "shoulders"],
                 ranked.map(&:name)
  end

  test "gap_ranked annotates each muscle with last_trained_on and days_since" do
    ranked = Muscle.gap_ranked(@main_user, today: @today).index_by(&:name)

    assert_equal Date.new(2026, 5, 28), ranked["back"].last_trained_on
    assert_equal 21, ranked["back"].days_since

    assert_equal Date.new(2026, 5, 12), ranked["legs"].last_trained_on
    assert_equal 37, ranked["legs"].days_since
  end

  test "a muscle is overdue once its gap exceeds the cadence, or it was never trained" do
    ranked = Muscle.gap_ranked(@main_user, today: @today).index_by(&:name)

    assert_predicate ranked["back"], :overdue?

    never_trained = Muscle.new
    never_trained.record_gap(nil, @today)

    assert_predicate never_trained, :overdue?
  end

  test "gap_ranked only counts the given user's workouts" do
    variation = exercise_variations(:lat_pulldown_default)
    main_workout = log_workout(variation, date: Date.new(2026, 6, 17), user: @main_user)

    ranked = Muscle.gap_ranked(@other_user, today: @today)
    last_trained_dates = ranked.map(&:last_trained_on)

    assert_not_includes last_trained_dates, main_workout.date
  end
end
