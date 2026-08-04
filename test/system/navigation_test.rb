# frozen_string_literal: true

require "application_system_test_case"

class NavigationTest < ApplicationSystemTestCase
  setup { sign_in_as(users(:one)) }

  test "desktop hides home and shows no visible active tab on the root" do
    visit root_path

    within ".nav" do
      assert_link "Plan", href: "/plan/edit"
      assert_link "History", href: "/workouts"
      assert_link "Progress", href: "/progress"
      assert_no_link "Home"
    end
    assert_no_selector ".nav a.active"
  end

  test "mobile shows all four tabs with home active on the root" do
    in_mobile_window do
      visit root_path

      within ".nav" do
        assert_link "Home", href: "/"
        assert_link "Plan", href: "/plan/edit"
        assert_link "History", href: "/workouts"
        assert_link "Progress", href: "/progress"
      end
      assert_selector ".nav .active", count: 1, text: "Home"
    end
  end

  test "mobile tabs navigate and move the active marker" do
    in_mobile_window do
      visit root_path
      within(".nav") { click_link "Progress" }

      assert_current_path "/progress"
      assert_selector ".nav .active", count: 1, text: "Progress"

      within(".nav") { click_link "Home" }

      assert_current_path "/"
      assert_selector ".nav .active", count: 1, text: "Home"
    end
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
    find(".brand").click

    assert_current_path "/"
  end

  private

  def in_mobile_window
    page.current_window.resize_to(390, 844)
    yield
  ensure
    page.current_window.resize_to(1400, 1400)
  end
end
