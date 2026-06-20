# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @workouts = Workout.includes(:muscles, :workout_exercises).order(date: :desc).limit(5)
    @total_count = Workout.count
    @month_count = Workout.where(date: Date.current.beginning_of_month..).count
  end
end
