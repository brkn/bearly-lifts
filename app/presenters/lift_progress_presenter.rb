# frozen_string_literal: true

class LiftProgressPresenter
  BADGE_LABELS = {
    progress: "+#{Suggestion::PROGRESSION_STEP}",
    hold: "HOLD",
    rebase: "REBASE",
  }.freeze

  def initialize(lift)
    @lift = lift
  end

  def badge_label
    BADGE_LABELS.fetch(trend)
  end

  def reads_as
    case trend
    when :progress then "Climbing · +#{Suggestion::PROGRESSION_STEP}"
    when :hold then "Stalled · hold #{format_weight(lift.current_weight)}"
    else "Cold · #{lift.days_idle}d idle"
    end
  end

  def working_set
    "#{format_weight(lift.current_weight)} kg × #{lift.current_reps}"
  end

  def point_label(point)
    "#{format_weight(point.weight)} kg × #{point.reps}"
  end

  def top_label
    "#{format_weight(lift.top_weight)} kg"
  end

  def delta_label
    sign = lift.delta_weight.negative? ? "" : "+"
    "#{sign}#{format_weight(lift.delta_weight)} kg"
  end

  def subtitle
    scheme = lift.weight_scheme ? lift.weight_scheme.tr("_", " ") : "free weight"
    "#{lift.muscle_name} · #{scheme} · #{lift.workouts_count} workouts"
  end

  private

  attr_reader :lift

  def trend
    lift.suggestion.trend
  end

  def format_weight(weight)
    format("%g", weight.to_f)
  end
end
