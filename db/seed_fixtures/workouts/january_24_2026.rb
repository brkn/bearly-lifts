# frozen_string_literal: true

module Workouts
  class January242026
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
        date: [2026, 1, 24],
        rpe: 7,
        duration_minutes: 90,
        notes: <<~NOTES.squish,
          Gym. 7 hours sleep, last meal skipped and not filling, energy 7/10, morning weight not measured, Concerta 54mg plus 240ml coffee plus 5g creatine (morning).
          Order as performed, with arms done first as an exercise-order strategy.
          Warmup: 20-25 minute treadmill, a warmup-volume Lateral Dumbbell Raise (12-15 x 2.5kg per hand), and a Chest Fly Machine baseline set (~12-15 x 20kg, found baseline weight).
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Standing DB biceps curl",
          notes: "Hard on third set but very good form throughout.",
          sets: [
            { reps: 12, weight: 5 },
            { reps: 12, weight: 5 },
            { reps: 11, weight: 5 },
          ],
        },
        {
          variation: "Cable Triceps Pushdown",
          notes: "Good form on all sets.",
          sets: [
            { reps: 12, weight: 20, notes: "kinda easy" },
            { reps: 12, weight: 20 },
            { reps: 12, weight: 20, notes: "burned" },
          ],
        },
        {
          variation: "Incline DB Bench Press",
          notes: "Shaky on last reps both sets. Only 2 sets completed.",
          sets: [
            { reps: 12, weight: 10 },
            { reps: 12, weight: 10 },
          ],
        },
        {
          variation: "Flat DB Bench Press",
          notes: "Limiting factor: everything burning, cumulative fatigue from incline.",
          sets: [
            { reps: 12, weight: 10, notes: "very shaky after rep 7" },
            { reps: 12, weight: 10, notes: "same shakiness" },
            { reps: 9, weight: 10, rir: 0 },
          ],
        },
        {
          variation: "Seated Cable Row",
          notes: "Limiting factor: weight jump too aggressive.",
          sets: [
            { reps: 12, weight: 35, notes: "not hard" },
            { reps: 12, weight: 35, notes: "felt burn but still easy" },
            { reps: 9, weight: 40, rir: 0 },
          ],
        },
      ]
    end
  end
end
