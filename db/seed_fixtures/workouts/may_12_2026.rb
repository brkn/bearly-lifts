# frozen_string_literal: true

module Workouts
  class May122026
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
        date: [2026, 5, 12],
        rpe: 6,
        duration_minutes: 35,
        notes: <<~NOTES.squish,
          8 hours sleep, protein bar 1 hour earlier, energy not recorded, morning weight 73.4kg, 5g creatine.
          Home session.
          Bent-over DB row was planned but not performed.
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Goblet Squat",
          notes: <<~NOTES.squish,
            Both DBs at chest, ~14kg total. Not hard, confirms home leg load ceiling. Activation-tier, not training.
          NOTES
          sets: [
            { reps: 15, weight: 14 },
            { reps: 15, weight: 14 },
            { reps: 15, weight: 14 },
          ],
        },
        {
          variation: "Standing DB biceps curl",
          notes: <<~NOTES.squish,
            No failure on any set. Clean 3x12 at 7kg. Post-comeback milestone.
          NOTES
          sets: [
            { reps: 12, weight: 7 },
            { reps: 12, weight: 7 },
            { reps: 12, weight: 7 },
          ],
        },
        {
          variation: "Dumbbell Shoulder Press",
          notes: <<~NOTES.squish,
            Superset with rear delt fly did not affect performance. Super set with the next exercise.
          NOTES
          sets: [
            { reps: 15, weight: 7 },
            { reps: 15, weight: 7 },
            { reps: 17, weight: 7, rir: 2, notes: "hard" },
          ],
        },
        {
          variation: "Dumbbell Rear Delt Fly",
          notes: <<~NOTES.squish,
            7kg too heavy for rear delts, form collapsed immediately.
            Super set with the previous exercise (dumbbell shoulder press).
          NOTES
          sets: [
            { reps: 11, weight: 7, notes: "very hard" },
            { reps: 12, weight: 7, notes: "horrible form" },
            { reps: 11, weight: 7, notes: "horrible form" },
          ],
        },
        {
          variation: "Dumbbell Skull Crusher",
          notes: <<~NOTES.squish,
            Limiting factor was muscular failure, the same fatigue cascade pattern.
          NOTES
          sets: [
            { reps: 13, weight: 7, rir: 2 },
            { reps: 9, weight: 7, rir: 0 },
            { reps: 5, weight: 7, rir: 0 },
          ],
        },
      ]
    end
  end
end
