# frozen_string_literal: true

module Workouts
  class August052025
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
        date: [2025, 8, 5],
        rpe: 7,
        duration_minutes: 90,
        notes: <<~NOTES.squish,
          5.5 hours sleep plus a 1 hour afternoon nap, last meal a döner wrap about 3.5 hours before, energy 6/10, morning weight 71kg, no supplements.
          At the gym.
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Flat DB Bench Press",
          sets: [
            { reps: 10, weight: 12.5 },
            { reps: 11, weight: 12.5 },
            { reps: 9, weight: 12.5 },
          ],
        },
        {
          variation: "Incline DB Bench Press",
          sets: [
            { reps: 10, weight: 10 },
            { reps: 10, weight: 10 },
            { reps: 9, weight: 10 },
          ],
        },
        {
          variation: "Machine Lat Pulldown",
          notes: <<~NOTES.squish,
            Close V-Grip attachment.
          NOTES
          sets: [
            { reps: 12, weight: 35 },
            { reps: 12, weight: 35 },
            { reps: 12, weight: 35 },
          ],
        },
        {
          variation: "Dumbbell Lateral Raise",
          sets: [
            { reps: 12, weight: 5 },
            { reps: 12, weight: 5, notes: "hard" },
            { reps: 12, weight: 5 },
          ],
        },
        {
          variation: "Standing DB biceps curl",
          notes: <<~NOTES.squish,
            Super set with the next exercise (Skull Crushers).
            Limiting factor was general muscle fatigue.
          NOTES
          sets: [
            { reps: 6, weight: 7.5, rir: 0 },
            { reps: 12, weight: 5 },
            { reps: 12, weight: 5 },
          ],
        },
        {
          variation: "Dumbbell Skull Crusher",
          notes: <<~NOTES.squish,
            Super set with the previous exercise (Standing Dumbbell Bicep Curls).
            Limiting factor was muscle instability and fatigue.
          NOTES
          sets: [
            { reps: 10, weight: 5, notes: "shaking" },
            { reps: 6, weight: 5, rir: 0 },
            { reps: 4, weight: 5, rir: 0 },
          ],
        },
      ]
    end
  end
end
