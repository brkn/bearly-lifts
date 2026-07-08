# frozen_string_literal: true

module Workouts
  class May212026
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
        date: [2026, 5, 21],
        rpe: 7,
        duration_minutes: 45,
        notes: <<~NOTES.squish,
          5 hours sleep, last meal not recorded, energy 6.5/10, morning weight not recorded, no supplements.
          Gym session.
          Lat Pulldown and Seated Cable Rows were skipped for the second consecutive session.
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Standing DB biceps curl",
          notes: <<~NOTES.squish,
            Super set with the next exercise (Cable Triceps Overhead Extension).
          NOTES
          sets: [
            { reps: 12, weight: 7.5 },
            { reps: 12, weight: 7.5 },
            { reps: 10, weight: 7.5, rir: 0, notes: "form held until last 2 reps" },
          ],
        },
        {
          variation: "Cable Triceps Overhead Extension",
          notes: <<~NOTES.squish,
            Super set with the previous exercise (Standing DB biceps curl).
          NOTES
          sets: [
            { reps: 12, weight: 27.5 },
            { reps: 12, weight: 27.5 },
            { reps: 12, weight: 27.5, notes: "form broke" },
          ],
        },
        {
          variation: "Incline DB Bench Press",
          sets: [
            { reps: 12, weight: 12.5 },
            { reps: 12, weight: 12.5 },
            { reps: 11, weight: 12.5, notes: "near drop" },
          ],
        },
        {
          variation: "Dumbbell Lateral Raise",
          sets: [
            { reps: 12, weight: 5 },
            { reps: 12, weight: 5 },
            { reps: 12, weight: 5, notes: "form broke on 2 sets" },
          ],
        },
        {
          variation: "Machine Rear Delt Fly",
          notes: <<~NOTES.squish,
            Performed on cable.
          NOTES
          sets: [
            { reps: 12, weight: 4, notes: "test, too easy" },
            { reps: 11, weight: 12, notes: "good burn, hard" },
            { reps: 10, weight: 12, rir: 0 },
            { reps: 8, weight: 12, rir: 0 },
          ],
        },
      ]
    end
  end
end
