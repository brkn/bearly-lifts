# frozen_string_literal: true

module Workouts
  class January102026
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
        date: [2026, 1, 10],
        rpe: 7,
        duration_minutes: nil,
        notes: <<~NOTES.squish,
          11 hours sleep, decent meal (specifics not recalled) 5 hours before, energy 8/10, morning weight not measured, Concerta 54mg plus 2 coffees.
          Gym, 19:30 Saturday, gym empty with a football match on.
          Warmup: 22-minute treadmill, 2.16km, incline mostly 5 degrees.
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Flat DB Bench Press",
          notes: "Decent burn on 3rd set.",
          sets: [
            { reps: 13, weight: 10 },
            { reps: 13, weight: 10 },
            { reps: 13, weight: 10 },
          ],
        },
        {
          variation: "Incline DB Bench Press",
          notes: "Limiting factor: shoulders and triceps burning, fatigue from doing this late in session.",
          sets: [
            { reps: 12, weight: 10 },
            { reps: 11, weight: 10, notes: "felt hard" },
            { reps: 7, weight: 10, rir: 0, notes: "shaky" },
          ],
        },
        {
          variation: "Standing DB biceps curl",
          notes: "Limiting factor: same detraining pattern as Jan 2.",
          sets: [
            { reps: 12, weight: 5 },
            { reps: 8, weight: 5, rir: 0 },
            { reps: 9, weight: 5, rir: 0 },
          ],
        },
        {
          variation: "Cable Triceps Pushdown",
          notes: "Strong progressive response.",
          sets: [
            { reps: 14, weight: 15, notes: "easy" },
            { reps: 14, weight: 20, notes: "light burn" },
            { reps: 14, weight: 25, notes: "decent hard, could do more" },
          ],
        },
        {
          variation: "Assisted Chin-ups",
          sets: [
            { reps: 9, weight: 0, notes: "10th pin from bottom, unknown assist amount" },
            { reps: 6, weight: 0, rir: 0 },
            { reps: 5, weight: 0, rir: 0 },
          ],
        },
        {
          variation: "Dumbbell Lateral Raise",
          sets: [
            { reps: 14, weight: 2.5, notes: "easy" },
            { reps: 13, weight: 2.5, notes: "easy" },
            { reps: 9, weight: 5, notes: "hard, bad form" },
          ],
        },
      ]
    end
  end
end
