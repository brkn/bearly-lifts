# frozen_string_literal: true

# Development seed data: three logged workout sessions (May 10, 21, 28 2026).
# The May 28 session is the one captured in
# .claude/session-logs/workout-session-may-28-2026.md; the earlier two are the
# sessions its notes cross-reference (tricep 27.5kg streak, rows 45kg ceiling).
#
# Catalog rows (exercises, variations, muscles) are found-or-created. The three
# seeded sessions are rebuilt on every run so re-seeding stays idempotent.

unless Rails.env.development?
  warn "db/seeds.rb only seeds the development environment. Skipping."
  return
end

muscles = %w[
  Shoulders
  Arms
  Back
].index_with { |name| Muscle.find_or_create_by!(name:) }

def default_variation(exercise_name, display_name, weight_scheme)
  exercise = Exercise.find_or_create_by!(name: exercise_name)
  exercise.exercise_variations.find_or_create_by!(name: display_name) do |variation|
    variation.weight_scheme = weight_scheme
    variation.is_default_variation = true
  end
end

lateral_raise   = default_variation("Lateral Dumbbell Raise", "Lateral Dumbbell Raise", :per_side)
tricep_overhead = default_variation("Tricep Overhead Cable Extension", "Tricep Overhead Cable Extension", :machine)
shoulder_press  = default_variation("Shoulder Press", "Machine Shoulder Press", :machine)
rear_delt_fly   = default_variation("Rear Delt Fly", "Rear Delt Fly", :machine)
lat_pulldown    = default_variation("Lat Pulldown", "Lat Pulldown (Close V-Grip)", :machine)
seated_row      = default_variation("Seated Cable Rows", "Seated Cable Rows", :machine)

def log_session(date:, rpe:, duration_minutes:, notes:)
  Session.where(date: date.all_day).destroy_all
  Session.create!(date:, rpe:, duration_minutes:, notes:)
end

def add_exercise(session, variation, sets:, muscles: [], notes: nil)
  session_exercise = session.session_exercises.create!(exercise_variation: variation, notes:)
  sets.each { |attributes| session_exercise.workout_sets.create!(**attributes) }
  muscles.each.with_index do |muscle, index|
    session_exercise.exercise_muscles.create!(muscle:, is_primary: index.zero?)
  end
  session_exercise
end

may_10 = log_session(
  date: Date.new(2026, 5, 10),
  rpe: 7,
  duration_minutes: 40,
  notes: "Pull day. Seated rows hit a new 45kg ceiling.",
)
add_exercise(
  may_10, lat_pulldown,
  muscles: [muscles["Back"], muscles["Arms"]],
  sets: [
    { reps: 12, weight: 35 },
    { reps: 12, weight: 35 },
    { reps: 10, weight: 35 },
  ],
)
add_exercise(
  may_10, seated_row,
  muscles: [muscles["Back"], muscles["Arms"]],
  notes: "New 45kg ceiling — 13/11/12 at 0 RIR.",
  sets: [
    { reps: 13, weight: 45, rir: 0 },
    { reps: 11, weight: 45, rir: 0 },
    { reps: 12, weight: 45, rir: 0 },
  ],
)
add_exercise(
  may_10, rear_delt_fly,
  muscles: [muscles["Shoulders"]],
  sets: [
    { reps: 12, weight: 6 },
    { reps: 12, weight: 6 },
  ],
)

may_21 = log_session(
  date: Date.new(2026, 5, 21),
  rpe: 7,
  duration_minutes: 42,
  notes: "Push day. Tricep 27.5kg held, rear delt 8kg felt easy.",
)
add_exercise(
  may_21, tricep_overhead,
  muscles: [muscles["Arms"]],
  notes: "3×12 at 27.5kg, set-3 shake. Holding the weight.",
  sets: [
    { reps: 12, weight: 27.5 },
    { reps: 12, weight: 27.5 },
    { reps: 12, weight: 27.5, notes: "shaky" },
  ],
)
add_exercise(
  may_21, rear_delt_fly,
  muscles: [muscles["Shoulders"]],
  notes: "Tested 8kg, felt easy — predict ready to own it.",
  sets: [
    { reps: 12, weight: 7 },
    { reps: 12, weight: 8 },
    { reps: 12, weight: 8 },
  ],
)
add_exercise(
  may_21, lateral_raise,
  muscles: [muscles["Shoulders"]],
  notes: "Working sets at 5kg/hand.",
  sets: [
    { reps: 15, weight: 5 },
    { reps: 12, weight: 5 },
    { reps: 12, weight: 5 },
  ],
)

may_28 = log_session(
  date: Date.new(2026, 5, 28),
  rpe: 7,
  duration_minutes: 35,
  notes: "Pull skip streak broken. Lat pulldown 37.5kg opened. Sleep 8h, big meal 1h prior.",
)
add_exercise(
  may_28, tricep_overhead,
  muscles: [muscles["Arms"]],
  notes: "Second straight 3×12 at 27.5kg. Matches May 21. Consolidated, not yet earned the bump.",
  sets: [
    { reps: 12, weight: 27.5 },
    { reps: 12, weight: 27.5 },
    { reps: 12, weight: 27.5, notes: "shaky" },
  ],
)
add_exercise(
  may_28, shoulder_press,
  muscles: [muscles["Shoulders"], muscles["Arms"]],
  notes: "First time on this machine. 30kg (15kg/side) too heavy — baseline, drop load next time.",
  sets: [{ reps: 6, weight: 30, rir: 0, notes: "failed, 15kg/side" }],
)
add_exercise(
  may_28, rear_delt_fly,
  muscles: [muscles["Shoulders"]],
  notes: "Clean 3×12 with room to spare — ready to progress.",
  sets: [
    { reps: 12, weight: 8, rir: 3 },
    { reps: 12, weight: 8, rir: 2 },
    { reps: 12, weight: 8, rir: 2 },
  ],
)
add_exercise(
  may_28, lat_pulldown,
  muscles: [muscles["Back"], muscles["Arms"]],
  notes: "First 37.5kg via DB-on-stack workaround. Repeat before pushing to 40.",
  sets: [
    { reps: 12, weight: 35 },
    { reps: 12, weight: 37.5, notes: "dumbbell-on-stack" },
    { reps: 8, weight: 37.5 },
  ],
)
add_exercise(
  may_28, seated_row,
  muscles: [muscles["Back"], muscles["Arms"]],
  notes: "Consolidating 45kg ceiling from May 10. Two sets — session cut short.",
  sets: [
    { reps: 12, weight: 45 },
    { reps: 12, weight: 45 },
  ],
)

Rails.logger.debug do
  "Seeded #{Session.count} sessions, #{SessionExercise.count} exercises, " \
    "#{WorkoutSet.count} sets across #{Muscle.count} muscles."
end
