# frozen_string_literal: true

module Workouts
  class August132025
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
        date: [2025, 8, 13],
        rpe: 3,
        duration_minutes: 90,
        notes: <<~NOTES.squish,
          5 hours sleep, chicken sandwich a couple hours earlier, energy not specified, morning weight 70.2kg, Ritalin 10mg + Concerta 27mg taken just before the workout.
          Home workout.
          90 minutes with long breaks between sets kept intensity low.
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Incline DB Bench Press",
          notes: nil,
          sets: [
            { reps: 20, weight: 7 },
            { reps: 20, weight: 7 },
            { reps: 20, weight: 7 },
          ],
        },
        {
          variation: "DB Chest Fly",
          notes: "Limited range of motion due to coffee table setup, but better than floor.",
          sets: [
            { reps: 15, weight: 7 },
            { reps: 16, weight: 7 },
            { reps: 16, weight: 7 },
          ],
        },
        {
          variation: "Dumbbell Lateral Raise",
          notes: "Limiting factor: fatigue.",
          sets: [
            { reps: 8, weight: 7 },
            { reps: 7, weight: 7 },
            { reps: 10, weight: 7 },
          ],
        },
        {
          variation: "Standing DB biceps curl",
          notes: <<~NOTES.squish,
            Burns the most and feels great.
            Consider doing earlier when less fatigued.
          NOTES
          sets: [
            { reps: 15, weight: 7, notes: "burning at rep 11" },
            { reps: 11, weight: 7, notes: "better form" },
            { reps: 16, weight: 7, notes: "worse form" },
          ],
        },
      ]
    end
  end
end
