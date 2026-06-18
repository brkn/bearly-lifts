# frozen_string_literal: true

require "simplecov-console"

SimpleCov.start "rails" do
  formatter SimpleCov::Formatter::Console

  enable_coverage :branch
  primary_coverage :branch

  add_filter "/test/"
  add_filter "/config/"
  add_filter "/vendor/"

  add_group "Models",      "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Views",       "app/views"
end
