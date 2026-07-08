# frozen_string_literal: true

module Workouts
  class January312026
    def self.seed!
      new.seed!
    end

    def seed!
      SeedWorkout.new(**workout_attributes).seed!(exercises)
    end

    private

    def workout_attributes
      {
        user: SeedDemoUsers.seed!,
        date: [2026, 1, 31],
        rpe: 4,
        duration_minutes: 40,
        notes: <<~NOTES.squish,
          Home workout, a light session 24 hours post-gym.
          Sleep, last meal, energy, morning weight and supplements not recorded.
          Session structured as a mixed / circuit style with exercises interleaved.
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Dumbbell Romanian Deadlift",
          notes: <<~NOTES.squish,
            Didn't feel hamstrings much, slight glute activation.
            Form uncertain, needs heavier load at gym to feel properly.
          NOTES
          sets: [
            { reps: 15, weight: 7 },
            { reps: 15, weight: 7 },
            { reps: 15, weight: 7 },
          ],
        },
        {
          variation: "Dumbbell Shoulder Press",
          notes: "Session highlight. Best stimulus of the workout.",
          sets: [
            { reps: 15, weight: 7 },
            { reps: 15, weight: 7, notes: "started feeling muscle" },
            { reps: 15, weight: 7, notes: "good burn, some right shoulder / lat clicking, no pain" },
          ],
        },
        {
          variation: "Shrugs",
          notes: <<~NOTES.squish,
            Too light, minimal stimulus.
            Needs gym weight. Revisit at gym in 10-14 days to reassess.
          NOTES
          sets: [
            { reps: 15, weight: 7 },
            { reps: 15, weight: 7 },
            { reps: 15, weight: 7 },
          ],
        },
        {
          variation: "Neck Pushes (Dumbbell Assisted)",
          notes: "Felt in control but 7kg is too heavy for comfort. Use 2.5kg or water bottle next time.",
          sets: [
            { reps: 6, weight: 7, notes: "held firmly, self-assisted" },
            { reps: 9, weight: 7 },
          ],
        },
        {
          variation: "Neck Extensions (Prone)",
          notes: "Didn't feel much. Baseline established.",
          sets: [
            { reps: 20, weight: 0 },
          ],
        },
        {
          variation: "Russian Twists",
          notes: <<~NOTES.squish,
            Manageable.
            Couldn't lift feet, glutes fatigued from squats (yesterday) + RDLs (today).
          NOTES
          sets: [
            { reps: 20, weight: 7, notes: "10 each side" },
            { reps: 20, weight: 7 },
          ],
        },
      ]
    end
  end
end
