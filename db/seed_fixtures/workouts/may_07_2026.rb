# frozen_string_literal: true

module Workouts
  class May072026
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
        date: [2026, 5, 7],
        rpe: 8,
        duration_minutes: 65,
        notes: <<~NOTES.squish,
          8 hours sleep, last meal 3 hours before, energy 9/10, morning weight not recorded, 300mg coffee.
          Istanbul USA gym.
          Arms trained first per order strategy.
          Warmed up with treadmill (duration not recorded) and a warmup set of lateral dumbbell raises per hand, not logged in detail.
          RDL was planned but replaced with flat bench; cable crunch was planned but pushed to next session.
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Preacher Curl",
          notes: <<~NOTES.squish,
            Bench support flattering the load.
          NOTES
          sets: [
            { reps: 14, weight: 7.5 },
            { reps: 14, weight: 7.5, rir: 2 },
          ],
        },
        {
          variation: "Standing DB biceps curl",
          notes: <<~NOTES.squish,
            Mid-exercise switch from preacher curl. Same weight, no bench lockout, real working load revealed. Plan: 7kg standing at home next session.
          NOTES
          sets: [
            { reps: 9, weight: 7.5, rir: 1, notes: "much harder" },
          ],
        },
        {
          variation: "Cable Triceps Overhead Extension",
          notes: <<~NOTES.squish,
            First clean 3x12 at 25kg post-comeback.
          NOTES
          sets: [
            { reps: 12, weight: 25, rir: 2 },
            { reps: 12, weight: 25, rir: 1 },
            { reps: 12, weight: 25, rir: 0 },
          ],
        },
        {
          variation: "Smith Squat",
          notes: <<~NOTES.squish,
            30kg added total, bar weight excluded.
          NOTES
          sets: [
            { reps: 12, weight: 15, rir: 1, notes: "barely" },
            { reps: 12, weight: 15, rir: 1, notes: "barely" },
            { reps: 13, weight: 15, rir: 1, notes: "barely" },
          ],
        },
        {
          variation: "Machine Lat Pulldown",
          notes: <<~NOTES.squish,
            32.5kg pin not available, forced jump to 35kg held cleanly.
          NOTES
          sets: [
            { reps: 13, weight: 30 },
            { reps: 12, weight: 35 },
            { reps: 13, weight: 35, rir: 0 },
          ],
        },
        {
          variation: "Flat DB Bench Press",
          sets: [
            { reps: 13, weight: 10 },
            { reps: 13, weight: 12.5 },
            { reps: 11, weight: 12.5, rir: 0 },
          ],
        },
      ]
    end
  end
end
