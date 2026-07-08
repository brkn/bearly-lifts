# frozen_string_literal: true

class SeedWorkout
  def initialize(
    user:,
    date:,
    rpe:,
    duration_minutes:,
    notes:
  )
    @user = user
    @date = Time.new(*date, 12, 0, 0, "+03:00").in_time_zone
    @rpe = rpe
    @duration_minutes = duration_minutes
    @notes = notes
  end

  def seed!(exercises)
    Workout.transaction do
      workout = Workout.create!(user:, date:, rpe:, duration_minutes:, notes:)

      exercises.each_with_index do |exercise_attrs, index|
        variation = ExerciseVariation.find_by!(name: exercise_attrs[:variation])

        workout.workout_exercises
               .create!(exercise_variation: variation, notes: exercise_attrs[:notes], position: index + 1)
               .create_sets!(exercise_attrs[:sets])
      end

      workout
    end
  end

  private

  attr_reader :user, :date, :rpe, :duration_minutes, :notes
end
