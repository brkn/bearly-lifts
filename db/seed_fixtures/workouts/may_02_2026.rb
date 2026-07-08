# frozen_string_literal: true

module Workouts
  class May022026
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
        date: [2026, 5, 2],
        rpe: 6,
        duration_minutes: 35,
        notes: <<~NOTES.squish,
          Sleep, last meal, energy, morning weight, and supplements not recorded.
          Saturday session at Red Gym, Balıkesir.
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Preacher Curl",
          notes: <<~NOTES.squish,
            First preacher curl session in logs. Establishing baseline.
          NOTES
          sets: [
            { reps: 12, weight: 5, notes: "many RIR" },
            { reps: 13, weight: 5, notes: "many RIR" },
            { reps: 13, weight: 7.5, notes: "RIR remaining" },
          ],
        },
        {
          variation: "Cable Triceps Overhead Extension",
          notes: <<~NOTES.squish,
            Cut short intentionally, avoiding post-session aches.
          NOTES
          sets: [
            { reps: 12, weight: 25, rir: 2, notes: "felt hard" },
            { reps: 13, weight: 25, rir: 1 },
          ],
        },
        {
          variation: "Incline DB Bench Press",
          notes: <<~NOTES.squish,
            First successful 12.5kg incline post-comeback. Jan 30 attempt was 10/6/6.
          NOTES
          sets: [
            { reps: 12, weight: 10, rir: 1, notes: "barely" },
            { reps: 10, weight: 12.5, rir: 0 },
            { reps: 10, weight: 12.5, rir: 0 },
          ],
        },
        {
          variation: "Seated Cable Row",
          notes: <<~NOTES.squish,
            First 40kg x 3x12. Locked in at new weight.
          NOTES
          sets: [
            { reps: 12, weight: 40, notes: "felt okay" },
            { reps: 12, weight: 40, rir: 1 },
            { reps: 12, weight: 40, rir: 1 },
          ],
        },
      ]
    end
  end
end
