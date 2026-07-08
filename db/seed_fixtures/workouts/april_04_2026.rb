# frozen_string_literal: true

module Workouts
  class April042026
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
        date: [2026, 4, 4],
        rpe: 6,
        duration_minutes: 60,
        notes: <<~NOTES.squish,
          Red Gym, Balıkesir.
          ~5 hours sleep, last meal at 12:20, energy 9/10, morning weight not measured, coffee only supplement.
          Saturday session around 14:30, quiet before 15:20 and crowded after.
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Dumbbell Lateral Raise",
          notes: "Light but muscle activation present.",
          sets: [
            { reps: 15, weight: 2.5 },
            { reps: 15, weight: 2.5 },
            { reps: 15, weight: 2.5 },
          ],
        },
        {
          variation: "Machine Lat Pulldown",
          notes: "Wide grip felt more natural. Stick with wide bar going forward.",
          sets: [
            { reps: 12, weight: 25, notes: "warmup, EZ-style attachment" },
            { reps: 13, weight: 30 },
            { reps: 12, weight: 30, rir: 4, notes: "switched to wide bar" },
          ],
        },
        {
          variation: "Standing DB biceps curl",
          notes: "Limiting factor: detraining. Same pattern as January comeback.",
          sets: [
            { reps: 12, weight: 5 },
            { reps: 9, weight: 5, notes: "form failure" },
            { reps: 10, weight: 5, notes: "last 4 reps form broke" },
          ],
        },
        {
          variation: "Cable Triceps Pushdown",
          notes: nil,
          sets: [
            { reps: 20, weight: 15, notes: "easy" },
            { reps: 10, weight: 20 },
            { reps: 10, weight: 20 },
          ],
        },
        {
          variation: "Flat DB Bench Press",
          notes: <<~NOTES.squish,
            Chest mind-muscle connection clicked on set 3 via intentional exaggeration.
            Activate from set 1 next time.
          NOTES
          sets: [
            { reps: 16, weight: 10, notes: "forgot to stop" },
            { reps: 12, weight: 10, notes: "2 reps left" },
            { reps: 14, weight: 10, rir: 1 },
          ],
        },
      ]
    end
  end
end
