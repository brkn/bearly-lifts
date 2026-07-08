# frozen_string_literal: true

module Workouts
  class May102026
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
        date: [2026, 5, 10],
        rpe: 8,
        duration_minutes: 40,
        notes: <<~NOTES.squish,
          8 hours sleep, protein bar 40 minutes before, energy 7/10, 450ml coffee, morning weight not recorded.
          Gym session.
          Also did 6 minutes of treadmill in addition to the 40-minute training portion.
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Machine Chest Fly",
          notes: <<~NOTES.squish,
            Big jump from April 7 (20kg x 13/12/12). 30kg now established as working weight.
          NOTES
          sets: [
            { reps: 13, weight: 25, rir: 3 },
            { reps: 13, weight: 30, rir: 1 },
            { reps: 12, weight: 30, rir: 0 },
          ],
        },
        {
          variation: "Dumbbell Lateral Raise",
          notes: <<~NOTES.squish,
            5kg locked in. Progression from April 29 (14 x 5kg, 2 RIR). Super set with the next exercise.
          NOTES
          sets: [
            { reps: 13, weight: 5, rir: 1 },
            { reps: 13, weight: 5, rir: 1 },
            { reps: 12, weight: 5, rir: 1 },
          ],
        },
        {
          variation: "Hammer Curls",
          notes: <<~NOTES.squish,
            First hammer curl session logged. Baseline at 7.5kg.
            Limiting factor was muscular failure, the same fatigue cascade pattern seen with curls during comeback.
            Super set with the previous exercise (lateral raise).
          NOTES
          sets: [
            { reps: 13, weight: 7.5, rir: 0 },
            { reps: 12, weight: 7.5, rir: 0 },
            { reps: 7, weight: 7.5, rir: 0 },
          ],
        },
        {
          variation: "Seated Cable Row",
          notes: <<~NOTES.squish,
            Up from 40kg x 3x12 on May 2. At edge, sets 2-3 at true failure.
          NOTES
          sets: [
            { reps: 13, weight: 45 },
            { reps: 11, weight: 45, rir: 0 },
            { reps: 12, weight: 45, rir: 0 },
          ],
        },
        {
          variation: "Machine Leg Extension",
          notes: <<~NOTES.squish,
            Silent screaming on last reps sets 2-3. First proper 3-set leg extension session. April 7 was a single 30kg x 12 baseline.
          NOTES
          sets: [
            { reps: 12, weight: 30 },
            { reps: 11, weight: 30, rir: 0 },
            { reps: 12, weight: 30, rir: 0 },
          ],
        },
        {
          variation: "Standing Leg Raises",
          notes: <<~NOTES.squish,
            Captain's chair / vertical knee raise. Sweating heavily, first time logging.
          NOTES
          sets: [
            { reps: 12, weight: 0 },
            { reps: 11, weight: 0 },
          ],
        },
      ]
    end
  end
end
