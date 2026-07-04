# frozen_string_literal: true

require "application_system_test_case"

class NavigationTest < ApplicationSystemTestCase
  test "home shows the three nav items with none active" do
    visit root_path

    within ".nav" do
      assert_link "Plan", href: "/plan/edit"
      assert_link "History", href: "/workouts"
      assert_link "Progress", href: "/progress"
    end
    assert_no_selector ".nav .active"
  end

  test "history is active on the workouts list, detail, and log screens" do
    visit root_path
    within(".nav") { click_link "History" }

    assert_current_path "/workouts"
    assert_selector ".nav .active", count: 1, text: "History"

    visit workout_path(workouts(:may12))
    assert_selector ".nav .active", count: 1, text: "History"

    visit new_workout_path
    assert_selector ".nav .active", count: 1, text: "History"
    within(".nav") { assert_no_text "Today" }
  end

  test "plan is active on the plan flow" do
    visit root_path
    within(".nav") { click_link "Plan" }

    assert_current_path "/plan/edit"
    assert_selector ".nav .active", count: 1, text: "Plan"
  end

  test "progress is active on the progress screen" do
    visit root_path
    within(".nav") { click_link "Progress" }

    assert_current_path "/progress"
    assert_selector ".nav .active", count: 1, text: "Progress"
  end

  test "brand wordmark links back home" do
    visit workouts_path
    click_link "Bearly Lifts"

    assert_current_path "/"
  end
end
