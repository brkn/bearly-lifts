# frozen_string_literal: true

module WorkoutTestHelper
  def log_workouts_on(days, user:)
    attributes = days.map { |day| { date: Time.zone.parse("#{day} 12:00"), rpe: 7 } }

    user.workouts.create!(attributes)
  end

  def log_workout(variation, date:, user:, sets: [])
    workout = user.workouts.create!(date:, rpe: 7)
    workout_exercise = workout.workout_exercises.create!(exercise_variation: variation, position: 1)

    sets.each_with_index.map { |(weight, reps, rir), index| { weight:, reps:, rir:, position: index + 1 } }
                        .presence
                        &.then { workout_exercise.workout_exercise_sets.create!(it) }

    workout
  end
end

ActiveSupport.on_load(:active_support_test_case) do
  include WorkoutTestHelper
end
