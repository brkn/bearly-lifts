# frozen_string_literal: true

class CadencePresenter
  Week = Data.define(:recent, :height)

  def initialize(cadence)
    @cadence = cadence
  end

  delegate :trend, :weekly_counts, :average, :recent_average, to: :cadence

  def weeks
    @weeks ||= weekly_counts.each_with_index.map { |count, index| build_week(count, index) }
  end

  def delta
    case trend
    when :up then "↑ from #{average}"
    when :down then "↓ from #{average}"
    else "steady"
    end
  end

  def lede
    case trend
    when :up then "Your last 4 weeks are running ahead of your 8-week average."
    when :down then "Your last 4 weeks are running behind your 8-week average."
    else "Your last 4 weeks match your 8-week average."
    end
  end

  def verdict
    case trend
    when :up then "Showing up more over the last month"
    when :down then "Showing up less over the last month"
    else "Holding steady over the last month"
    end
  end

  def height_for_average
    percent_of_max(average)
  end

  def height_for_recent_average
    percent_of_max(recent_average)
  end

  private

  attr_reader :cadence

  def percent_of_max(value)
    (value / best_weeks_workout_count.to_f * 100).round(1)
  end

  def best_weeks_workout_count
    [weekly_counts.max, 1].max
  end

  def build_week(count, index)
    is_recent = index >= Cadence::WEEKS - Cadence::RECENT_WEEKS

    Week.new(recent: is_recent, height: percent_of_max(count))
  end
end
