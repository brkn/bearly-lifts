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

  def new
    @workout = Workout.new
  end

  def create
    @workout = Workout.new(workout_params.slice(:rpe, :notes))

    Workout.transaction do
      @workout.save!

      workout_params[:workout_exercises].each_with_index do |exercise_attrs, index|
        @workout.workout_exercises
                .create!(position: index + 1,
                         **exercise_attrs.slice(:exercise_variation_id, :notes),)
                .create_sets!(exercise_attrs[:workout_exercise_sets])
      end
    end

    redirect_to @workout
  rescue ActiveRecord::RecordInvalid
    # TODO: Validation errors on nested records (exercises/sets) should be visible to the user.
    render :new, status: :unprocessable_content
  end

  private

  def workout_params
    @workout_params ||= params.expect(
      workout: [
        :rpe,
        :notes,
        {
          workout_exercises: [[
            :exercise_variation_id,
            :notes,
            { workout_exercise_sets: [[:reps, :weight, :rir, :notes]] },
          ]],
        },
      ],
    )
  end
end
