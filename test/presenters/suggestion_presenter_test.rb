# frozen_string_literal: true

require "test_helper"

class SuggestionPresenterTest < ActiveSupport::TestCase
  test "trend_label reflects the trend" do
    {
      progress: "↑ +#{Suggestion::PROGRESSION_STEP}kg",
      hold: "hold",
      rebase: "re-base",
    }.each do |trend, label|
      suggestion = Suggestion.new(trend:, weight: 40)

      assert_equal label, SuggestionPresenter.new(suggestion).trend_label
    end
  end

  test "trend_class is blank for progress and the trend name otherwise" do
    {
      progress: "",
      hold: "hold",
      rebase: "rebase",
    }.each do |trend, css_class|
      suggestion = Suggestion.new(trend:, weight: 40)

      assert_equal css_class, SuggestionPresenter.new(suggestion).trend_class
    end
  end
end
