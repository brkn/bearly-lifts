# frozen_string_literal: true

# Development seed data: three logged workouts (May 10, 21, 28 2026).
# The May 28 workout is the one captured in
# .claude/session-logs/workout-session-may-28-2026.md; the earlier two are the
# workouts its notes cross-reference (tricep 27.5kg streak, rows 45kg ceiling).
#
# Catalog rows (exercises, variations, muscles) are found-or-created. The three
# seeded workouts are rebuilt on every run so re-seeding stays idempotent.

unless Rails.env.development?
  warn "db/seeds.rb only seeds the development environment. Skipping."
  return
end

muscles = %w[
  Shoulders
  Arms
  Back
].index_with { |name| Muscle.find_or_create_by!(name:) }

def default_variation(exercise_name, display_name, weight_scheme, trains:)
  exercise = Exercise.find_or_create_by!(name: exercise_name)
  variation = exercise.exercise_variations.find_or_create_by!(name: display_name) do |v|
    v.weight_scheme = weight_scheme
    v.is_default_variation = true
  end
  trains.each.with_index do |muscle, index|
    variation.exercise_muscles.find_or_create_by!(muscle:) { |em| em.is_primary = index.zero? }
  end
  variation
end

lateral_raise = default_variation("Lateral Dumbbell Raise", "Lateral Dumbbell Raise", :per_side,
                                  trains: [muscles["Shoulders"]],)
tricep_overhead = default_variation("Tricep Overhead Cable Extension", "Tricep Overhead Cable Extension", :machine,
                                    trains: [muscles["Arms"]],)
shoulder_press = default_variation("Shoulder Press", "Machine Shoulder Press", :machine,
                                   trains: [muscles["Shoulders"], muscles["Arms"]],)
rear_delt_fly   = default_variation("Rear Delt Fly", "Rear Delt Fly", :machine, trains: [muscles["Shoulders"]])
lat_pulldown    = default_variation("Lat Pulldown", "Lat Pulldown (Close V-Grip)", :machine,
                                    trains: [muscles["Back"], muscles["Arms"]],)
seated_row = default_variation("Seated Cable Rows", "Seated Cable Rows", :machine,
                               trains: [muscles["Back"], muscles["Arms"]],)

def log_workout(date:, rpe:, duration_minutes:, notes:)
  Workout.where(date: date.all_day).destroy_all
  Workout.create!(date:, rpe:, duration_minutes:, notes:)
end

def add_exercise(workout, variation, sets:, notes: nil)
  workout_exercise = workout.workout_exercises.create!(
    exercise_variation: variation,
    position: workout.workout_exercises.count + 1,
    notes:,
  )
  sets.each { |attributes| workout_exercise.workout_exercise_sets.create!(**attributes) }
  workout_exercise
end

may10 = log_workout(
  date: Date.new(2026, 5, 10),
  rpe: 7,
  duration_minutes: 40,
  notes: "Pull day. Seated rows hit a new 45kg ceiling.",
)
add_exercise(
  may10, lat_pulldown,
  sets: [
    { reps: 12, weight: 35 },
    { reps: 12, weight: 35 },
    { reps: 10, weight: 35 },
  ],
)
add_exercise(
  may10, seated_row,
  notes: "New 45kg ceiling — 13/11/12 at 0 RIR.",
  sets: [
    { reps: 13, weight: 45, rir: 0 },
    { reps: 11, weight: 45, rir: 0 },
    { reps: 12, weight: 45, rir: 0 },
  ],
)
add_exercise(
  may10, rear_delt_fly,
  sets: [
    { reps: 12, weight: 6 },
    { reps: 12, weight: 6 },
  ],
)

may21 = log_workout(
  date: Date.new(2026, 5, 21),
  rpe: 7,
  duration_minutes: 42,
  notes: "Push day. Tricep 27.5kg held, rear delt 8kg felt easy.",
)
add_exercise(
  may21, tricep_overhead,
  notes: "3×12 at 27.5kg, set-3 shake. Holding the weight.",
  sets: [
    { reps: 12, weight: 27.5 },
    { reps: 12, weight: 27.5 },
    { reps: 12, weight: 27.5, notes: "shaky" },
  ],
)
add_exercise(
  may21, rear_delt_fly,
  notes: "Tested 8kg, felt easy — predict ready to own it.",
  sets: [
    { reps: 12, weight: 7 },
    { reps: 12, weight: 8 },
    { reps: 12, weight: 8 },
  ],
)
add_exercise(
  may21, lateral_raise,
  notes: "Working sets at 5kg/hand.",
  sets: [
    { reps: 15, weight: 5 },
    { reps: 12, weight: 5 },
    { reps: 12, weight: 5 },
  ],
)

may28 = log_workout(
  date: Date.new(2026, 5, 28),
  rpe: 7,
  duration_minutes: 35,
  notes: "Pull skip streak broken. Lat pulldown 37.5kg opened. Sleep 8h, big meal 1h prior.",
)
add_exercise(
  may28, tricep_overhead,
  notes: "Second straight 3×12 at 27.5kg. Matches May 21. Consolidated, not yet earned the bump.",
  sets: [
    { reps: 12, weight: 27.5 },
    { reps: 12, weight: 27.5 },
    { reps: 12, weight: 27.5, notes: "shaky" },
  ],
)
add_exercise(
  may28, shoulder_press,
  notes: "First time on this machine. 30kg (15kg/side) too heavy — baseline, drop load next time.",
  sets: [{ reps: 6, weight: 30, rir: 0, notes: "failed, 15kg/side" }],
)
add_exercise(
  may28, rear_delt_fly,
  notes: "Clean 3×12 with room to spare — ready to progress.",
  sets: [
    { reps: 12, weight: 8, rir: 3 },
    { reps: 12, weight: 8, rir: 2 },
    { reps: 12, weight: 8, rir: 2 },
  ],
)
add_exercise(
  may28, lat_pulldown,
  notes: "First 37.5kg via DB-on-stack workaround. Repeat before pushing to 40.",
  sets: [
    { reps: 12, weight: 35 },
    { reps: 12, weight: 37.5, notes: "dumbbell-on-stack" },
    { reps: 8, weight: 37.5 },
  ],
)
add_exercise(
  may28, seated_row,
  notes: "Consolidating 45kg ceiling from May 10. Two sets — workout cut short.",
  sets: [
    { reps: 12, weight: 45 },
    { reps: 12, weight: 45 },
  ],
)

Rails.logger.debug do
  "Seeded #{Workout.count} workouts, #{WorkoutExercise.count} exercises, " \
    "#{WorkoutExerciseSet.count} sets across #{Muscle.count} muscles."
end
