# frozen_string_literal: true

module Workouts
  class April072026
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
        date: [2026, 4, 7],
        rpe: 6,
        duration_minutes: 40,
        notes: <<~NOTES.squish,
          5 hours sleep, last meal about 2 hours before, energy 8/10, morning weight not measured, 2 coffees.
          Arms aching and back pain going in, likely treadmill-related.
          At the gym.
          Warmed up with 6 minutes on the treadmill before exercises.
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Cable Triceps Pushdown",
          notes: <<~NOTES.squish,
            Jumped to 25kg and maintained solid volume.
            Stronger than April 4 (10/10 at 20kg).
            No direct arm isolation otherwise.
          NOTES
          sets: [
            { reps: 13, weight: 20 },
            { reps: 9, weight: 20 },
            { reps: 12, weight: 25 },
            { reps: 11, weight: 25 },
          ],
        },
        {
          variation: "Machine Leg Extension",
          notes: <<~NOTES.squish,
            First time doing leg extensions.
            Baseline established.
          NOTES
          sets: [
            { reps: 12, weight: 30 },
          ],
        },
        {
          variation: "Incline DB Bench Press",
          notes: <<~NOTES.squish,
            Consistent performance, stronger than April 4 flat bench equivalent.
          NOTES
          sets: [
            { reps: 13, weight: 10 },
            { reps: 13, weight: 10 },
            { reps: 12, weight: 10 },
          ],
        },
        {
          variation: "Machine Chest Fly",
          sets: [
            { reps: 13, weight: 20 },
            { reps: 12, weight: 20 },
            { reps: 12, weight: 20 },
          ],
        },
        {
          variation: "Seated Cable Row",
          notes: <<~NOTES.squish,
            Limiting factor was back pain; wisely reduced load.
          NOTES
          sets: [
            { reps: 12, weight: 35 },
            { reps: 11, weight: 30, notes: "dropped weight" },
          ],
        },
      ]
    end
  end
end
