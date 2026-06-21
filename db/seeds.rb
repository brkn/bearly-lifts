# frozen_string_literal: true

unless Rails.env.development?
  warn "db/seeds.rb only seeds the development environment. Skipping."
  return
end

fixtures_path = Rails.root.join("test/fixtures")
fixture_names = fixtures_path.glob("**/*.yml").map do |file|
  file.relative_path_from(fixtures_path).to_s.delete_suffix(".yml")
end

ActiveRecord::FixtureSet.create_fixtures(fixtures_path, fixture_names)

Rails.logger.debug do
  "Seeded #{Workout.count} workouts, #{WorkoutExercise.count} exercises, " \
    "#{WorkoutExerciseSet.count} sets across #{Muscle.count} muscles."
end
