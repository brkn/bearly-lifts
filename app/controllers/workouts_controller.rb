# frozen_string_literal: true

class WorkoutsController < ApplicationController
  def index
    @workouts = Current.user.workouts.includes(:muscles, :workout_exercises).order(date: :desc)
    @total_count = @workouts.size
    @month_count = @workouts.count { |w| w.date >= Date.current.beginning_of_month }
  end

  def show
    @workout = Current.user.workouts
                      .includes(:muscles, workout_exercises: [:exercise_variation, :workout_exercise_sets])
                      .find(params.expect(:id))
  end

  def new
    @workout = Current.user.workouts.new
  end

  def create
    @workout = Current.user.workouts.new(workout_params.slice(:rpe, :notes))

    Workout.transaction do
      @workout.save!

      # TODO: Add test case for `:workout_exercises` param being nil.
      workout_params[:workout_exercises].each_with_index do |exercise_attrs, index|
        @workout.workout_exercises
                .create!(exercise_attrs.slice(:exercise_variation_id, :notes).merge(position: index + 1))
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
