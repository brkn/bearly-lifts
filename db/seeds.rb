# frozen_string_literal: true

unless Rails.env.development?
  warn "db/seeds.rb only seeds the development environment. Skipping."
  return
end

SeedMuscles.seed!
SeedExercisesWithVariations.seed!
SeedExerciseMuscles.seed!

Rails.root.glob("db/seed_fixtures/workouts/*.rb")
     .sort_by { |file| Date.parse(file.basename(".rb").to_s.tr("_", " ")) }
     .each { |file| "Workouts::#{file.basename('.rb').to_s.camelize}".constantize.seed! }

Rails.logger.debug do
  "Seeded #{Workout.count} workouts, #{WorkoutExercise.count} exercises, " \
    "#{WorkoutExerciseSet.count} sets across #{Muscle.count} muscles."
end
