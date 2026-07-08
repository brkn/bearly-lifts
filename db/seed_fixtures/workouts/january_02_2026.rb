# frozen_string_literal: true

module Workouts
  class January022026
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
        date: [2026, 1, 2],
        rpe: 6,
        duration_minutes: 45,
        notes: <<~NOTES.squish,
          6 hours sleep, last meal a cheese sandwich about 1.5 hours before, energy 8/10, morning weight 70.7kg, nescafe.
          At the gym.
          20 minute treadmill walk in addition to the 45 minute session.
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Incline DB Bench Press",
          notes: <<~NOTES.squish,
            Easy. Chest strength maintained well.
          NOTES
          sets: [
            { reps: 13, weight: 7.5 },
            { reps: 13, weight: 7.5 },
            { reps: 13, weight: 7.5 },
          ],
        },
        {
          variation: "Flat DB Bench Press",
          sets: [
            { reps: 12, weight: 7.5 },
            { reps: 12, weight: 7.5 },
            { reps: 12, weight: 7.5 },
          ],
        },
        {
          variation: "Standing DB biceps curl",
          notes: <<~NOTES.squish,
            Limiting factor was rapid fatigue after months off.
          NOTES
          sets: [
            { reps: 12, weight: 5, notes: "easy" },
            { reps: 8, weight: 5, rir: 0 },
            { reps: 12, weight: 2.5, notes: "dropped weight" },
          ],
        },
        {
          variation: "Cable Triceps Pushdown",
          notes: <<~NOTES.squish,
            Limiting factor was fatigue plus mentally checking out.
          NOTES
          sets: [
            { reps: 10, weight: 15 },
            { reps: 11, weight: 15 },
            { reps: 8, weight: 10, rir: 0, notes: "got bored" },
          ],
        },
        {
          variation: "Dumbbell Lateral Raise",
          notes: <<~NOTES.squish,
            Very easy.
          NOTES
          sets: [
            { reps: 13, weight: 2.5 },
            { reps: 13, weight: 2.5 },
            { reps: 13, weight: 2.5 },
          ],
        },
      ]
    end
  end
end
