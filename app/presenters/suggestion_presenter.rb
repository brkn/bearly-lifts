# frozen_string_literal: true

class SuggestionPresenter
  TREND_LABELS = {
    progress: "↑ +#{Suggestion::PROGRESSION_STEP}kg",
    hold: "hold",
    rebase: "re-base",
  }.freeze

  def initialize(suggestion)
    @suggestion = suggestion
  end

  def trend_label
    TREND_LABELS.fetch(@suggestion.trend)
  end

  def trend_class
    return "" if @suggestion.trend == :progress

    @suggestion.trend.to_s
  end
end
