# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "plan returns the user's plan" do
    assert_equal plans(:current), users(:one).plan
  end

  test "plan is nil for a user without a plan" do
    assert_nil users(:two).plan
  end
end
