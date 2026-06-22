# frozen_string_literal: true

class WorkoutsController < ApplicationController
  def index
    @workouts = Workout.includes(:muscles, :workout_exercises).order(date: :desc)
    @total_count = @workouts.size
    @month_count = @workouts.count { |w| w.date >= Date.current.beginning_of_month }
  end

  def show
    @workout = Workout
               .includes(:muscles, workout_exercises: [:exercise_variation, :workout_exercise_sets])
               .find(params.expect(:id))
  end
end
