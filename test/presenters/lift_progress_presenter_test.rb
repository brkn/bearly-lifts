# frozen_string_literal: true

require "test_helper"

class LiftProgressPresenterTest < ActiveSupport::TestCase
  FakeLift = Struct.new(
    :suggestion, :current_weight, :current_reps, :top_weight, :delta_weight,
    :days_idle, :workouts_count, :muscle_name, :weight_scheme,
    keyword_init: true,
  )

  test "badge label per trend" do
    assert_equal "+2.5", presenter(trend: :progress).badge_label
    assert_equal "HOLD", presenter(trend: :hold).badge_label
    assert_equal "REBASE", presenter(trend: :rebase).badge_label
  end

  test "reads_as summarises the trend with the relevant number" do
    assert_equal "Climbing · +2.5", presenter(trend: :progress).reads_as
    assert_equal "Stalled · hold 17.5", presenter(trend: :hold, current_weight: 17.5).reads_as
    assert_equal "Cold · 38d idle", presenter(trend: :rebase, days_idle: 38).reads_as
  end

  test "working_set formats weight and reps, dropping trailing zeros" do
    assert_equal "15 kg × 10", presenter(current_weight: BigDecimal("15.0"), current_reps: 10).working_set
    assert_equal "7.5 kg × 12", presenter(current_weight: BigDecimal("7.5"), current_reps: 12).working_set
  end

  test "point_label formats any history point" do
    point = LiftProgress::Point.new(
      date: Date.new(2026, 6, 1), weight: BigDecimal("12.5"), reps: 9, rir: nil, sets_count: 3,
    )

    assert_equal "12.5 kg × 9", presenter.point_label(point)
  end

  test "top_label and delta_label" do
    p = presenter(top_weight: BigDecimal("20"), delta_weight: BigDecimal("7.5"))

    assert_equal "20 kg", p.top_label
    assert_equal "+7.5 kg", p.delta_label
    assert_equal "-2.5 kg", presenter(delta_weight: BigDecimal("-2.5")).delta_label
    assert_equal "+0 kg", presenter(delta_weight: 0).delta_label
  end

  test "subtitle joins muscle, scheme and workout count" do
    p = presenter(muscle_name: "Back", weight_scheme: "machine", workouts_count: 7)

    assert_equal "Back · machine · 7 workouts", p.subtitle
  end

  test "subtitle falls back to free weight and humanises per_side" do
    assert_equal "Chest · free weight · 3 workouts",
                 presenter(muscle_name: "Chest", weight_scheme: nil, workouts_count: 3).subtitle
    assert_equal "Chest · per side · 3 workouts",
                 presenter(muscle_name: "Chest", weight_scheme: "per_side", workouts_count: 3).subtitle
  end

  private

  def presenter(trend: :progress, **attrs)
    lift = FakeLift.new(
      suggestion: Suggestion.new(trend: trend, weight: attrs[:current_weight] || 40),
      current_weight: 40, current_reps: 8, top_weight: 40, delta_weight: 0,
      days_idle: 5, workouts_count: 4, muscle_name: "Back", weight_scheme: "machine",
      **attrs,
    )
    LiftProgressPresenter.new(lift)
  end
end
