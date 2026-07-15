# frozen_string_literal: true

class Cadence
  WEEKS = 8
  RECENT_WEEKS = 4

  def initialize(workouts)
    @workouts = workouts
  end

  delegate_missing_to :presenter

  def weekly_counts
    @weekly_counts ||= (0...WEEKS).map { |offset| window_start + offset.weeks }
                                  .map { |week_start| counts_by_week.fetch(week_start, 0) }
  end

  def average
    (weekly_counts.sum / WEEKS.to_f).round(1)
  end

  def recent_average
    (weekly_counts.last(RECENT_WEEKS).sum / RECENT_WEEKS.to_f).round(1)
  end

  def trend
    case recent_average <=> average
    when 1 then :up
    when 0 then :flat
    when -1 then :down
    end
  end

  def presenter
    @presenter ||= CadencePresenter.new(self)
  end

  private

  def window_start
    @window_start ||= (WEEKS - 1).weeks.ago.to_date.beginning_of_week
  end

  def counts_by_week
    @counts_by_week ||= @workouts.where(date: window_start.in_time_zone..)
                                 .pluck(:date)
                                 .group_by { |date| date.to_date.beginning_of_week }
                                 .transform_values(&:size)
  end
end
