# frozen_string_literal: true

module Workouts
  class January122026
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
        date: [2026, 1, 12],
        rpe: 7,
        duration_minutes: nil,
        notes: <<~NOTES.squish,
          Gym session. Sleep, last meal, energy, morning weight, and supplements not recorded.
          Order as performed, with arms done first as an exercise-order test.
          Warmup: treadmill (duration not recorded) plus a warmup-volume Lateral Dumbbell Raise, 13 x 2.5kg per hand.
          Session RPE is an estimate.
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Standing DB biceps curl",
          notes: "Better performance than previous sessions. Doing biceps first helped.",
          sets: [
            { reps: 13, weight: 5, notes: "very good form" },
            { reps: 13, weight: 5, notes: "last 4 reps shaky" },
            { reps: 9, weight: 5, rir: 0 },
          ],
        },
        {
          variation: "Incline DB Bench Press",
          notes: "Much better than Jan 10 when done late (7 reps to failure). Exercise order confirmed.",
          sets: [
            { reps: 12, weight: 10, notes: "could do 3 more" },
            { reps: 12, weight: 10, notes: "hard, could do 1 more" },
            { reps: 11, weight: 10, rir: 0 },
          ],
        },
        {
          variation: "Flat DB Bench Press",
          notes: "Limiting factor: cumulative fatigue from earlier pressing.",
          sets: [
            { reps: 12, weight: 12.5, notes: "exhausted" },
            { reps: 7, weight: 12.5, rir: 0 },
            { reps: 4, weight: 12.5, rir: 0 },
          ],
        },
        {
          variation: "Machine Lat Pulldown",
          notes: "Weight jump to 35kg too aggressive mid-workout.",
          sets: [
            { reps: 13, weight: 30, notes: "decent, could do 1 more" },
            { reps: 9, weight: 35, notes: "shaky, exhausted" },
            { reps: 13, weight: 30, notes: "okay but exhausted" },
          ],
        },
        {
          variation: "Assisted Dips",
          sets: [
            { reps: 10, weight: 0, notes: "unknown assistance level, felt very easy" },
          ],
        },
        {
          variation: "Cable Triceps Pushdown",
          notes: "Limiting factor: fatigue from pressing movements.",
          sets: [
            { reps: 13, weight: 20 },
            { reps: 9, weight: 20 },
            { reps: 9, weight: 20 },
          ],
        },
      ]
    end
  end
end
