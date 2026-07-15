# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @workouts = Current.user.workouts.includes(:muscles, :workout_exercises).order(date: :desc).limit(5)
    @total_count = Current.user.workouts.count
    @month_count = Current.user.workouts.where(date: Date.current.beginning_of_month..).count
    @cadence = Cadence.new(Current.user.workouts)
  end
end
