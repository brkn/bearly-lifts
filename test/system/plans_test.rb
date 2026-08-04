# frozen_string_literal: true

require "application_system_test_case"

class PlansTest < ApplicationSystemTestCase
  setup { sign_in_as(users(:one)) }

  test "picking muscles carries them to the exercises step as one compact param" do
    visit new_plan_path

    all(".opt input[type=checkbox]").each(&:uncheck)
    find(".opt input[value=legs]").check
    find(".opt input[value=posterior-chain]").check
    click_button "Next: Exercises →"

    assert_current_path "/plan/exercises?muscles=legs,posterior-chain"
    assert_selector ".group h2", text: "Legs"
    assert_selector ".group h2", text: "Posterior Chain"
  end
end
