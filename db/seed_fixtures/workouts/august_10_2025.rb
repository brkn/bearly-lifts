# frozen_string_literal: true

module Workouts
  class August102025
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
        date: [2025, 8, 10],
        rpe: 6,
        duration_minutes: 40,
        notes: <<~NOTES.squish,
          8 hours sleep (great sleep), cheese melt toast eaten 4 hours before, energy 7/10, morning weight 71.5kg, no supplements.
          Home workout due to not feeling well.
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Dumbbell Shoulder Press",
          notes: nil,
          sets: [
            { reps: 12, weight: 7 },
            { reps: 12, weight: 7 },
            { reps: 12, weight: 7 },
          ],
        },
        {
          variation: "Lunges",
          notes: "Limiting factor: balance issues on stepping down.",
          sets: [
            { reps: 12, weight: 14 },
          ],
        },
        {
          variation: "Goblet Squat",
          notes: nil,
          sets: [
            { reps: 12, weight: 14 },
            { reps: 12, weight: 14 },
            { reps: 12, weight: 14 },
          ],
        },
        {
          variation: "Standing DB biceps curl",
          notes: "Near perfect form throughout.",
          sets: [
            { reps: 12, weight: 7 },
            { reps: 12, weight: 7 },
            { reps: 12, weight: 7, notes: "burning on last reps" },
          ],
        },
      ]
    end
  end
end
