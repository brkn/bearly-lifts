# frozen_string_literal: true

if ENV["COVERAGE"]
  require "simplecov"
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
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
Rails.root.glob("test/test_helpers/**/*.rb").each { |helper| require helper }

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)

    if ENV["COVERAGE"]
      parallelize_setup do |worker|
        SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
      end

      parallelize_teardown do |_worker|
        SimpleCov.result
      end
    end

    fixtures :all
  end
end
