# frozen_string_literal: true

class Suggestion
  PROGRESSION_STEP = 2.5
  STALE_AFTER_DAYS = 28
  CLEARED_RIR = 2

  def initialize(trend:, weight:, sets:, reps:)
    @trend = trend
    @weight = weight
    @sets = sets
    @reps = reps
  end

  attr_reader :trend, :weight, :sets, :reps

  def ==(other)
    other.is_a?(Suggestion) &&
      trend == other.trend &&
      weight == other.weight &&
      sets == other.sets &&
      reps == other.reps
  end

  class << self
    def from(sets, performed_on:, today:)
      top_weight = sets.map(&:weight).max
      top_sets = sets.select { |s| s.weight == top_weight }
      trend = compute_trend(top_sets, performed_on, today)
      weight = trend == :progress ? top_weight + PROGRESSION_STEP : top_weight

      new(trend:, weight:, sets: sets.size, reps: top_sets.map(&:reps).max)
    end

    def new_rebase_suggestion
      new(trend: :rebase, weight: nil, sets: nil, reps: nil)
    end

    private

    def compute_trend(top_sets, performed_on, today)
      return :rebase if (today - performed_on).to_i > STALE_AFTER_DAYS

      rirs = top_sets.map(&:rir)
      return :hold if rirs.include?(0)
      return :progress if rirs.all? { |rir| rir.to_i >= CLEARED_RIR }

      :hold
    end
  end
end
