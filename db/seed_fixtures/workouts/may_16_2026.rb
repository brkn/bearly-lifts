# frozen_string_literal: true

module Workouts
  class May162026
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
        date: [2026, 5, 16],
        rpe: 7,
        duration_minutes: 55,
        notes: <<~NOTES.squish,
          7 hours sleep, protein bar before start, energy and morning weight not recorded, 250ml coffee.
          Gym session.
          Warmed up with 6 minutes of treadmill at 5 km/h and a warmup set of 20 x 2.5kg lateral dumbbell raises per hand.
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Cable Triceps Pushdown",
          notes: <<~NOTES.squish,
            New working weight. First 30kg cable pushdown. Up from April 7's 25kg x 12/11.
          NOTES
          sets: [
            { reps: 12, weight: 25, rir: 4 },
            { reps: 13, weight: 30, rir: 3 },
            { reps: 10, weight: 30, rir: 0 },
          ],
        },
        {
          variation: "Standing DB biceps curl",
          notes: <<~NOTES.squish,
            PR session. May 7 was 7.5kg x 9 reps (1 RIR). Today: clean 3x12 with RIR remaining throughout.
          NOTES
          sets: [
            { reps: 12, weight: 7.5, rir: 3 },
            { reps: 12, weight: 7.5, rir: 1 },
            { reps: 12, weight: 7.5, rir: 1 },
          ],
        },
        {
          variation: "Dumbbell Lateral Raise",
          notes: <<~NOTES.squish,
            Feels easy now. Trying refined form. 5kg consolidated, ready to test heavier.
          NOTES
          sets: [
            { reps: 12, weight: 5 },
            { reps: 12, weight: 5 },
            { reps: 12, weight: 5 },
          ],
        },
        {
          variation: "Dumbbell Romanian Deadlift",
          notes: <<~NOTES.squish,
            Painful and awkward. Different signal than April 29, which held cleanly. Not the old right-lower-back flag, this is a hip hinge mechanics issue.
            Limiting factor: form, not load. Feeling load in upper back/shoulders, not hips/hamstrings. Hinge breaking down.
          NOTES
          sets: [
            { reps: 13, weight: 17.5 },
            { reps: 12, weight: 17.5 },
            { reps: 11, weight: 17.5 },
          ],
        },
        {
          variation: "Incline DB Bench Press",
          notes: <<~NOTES.squish,
            Consolidated 12.5kg. Up from May 2's 12.5kg x 10/10 failure. Ready to test higher next session.
          NOTES
          sets: [
            { reps: 12, weight: 12.5, rir: 1 },
            { reps: 12, weight: 12.5, rir: 0 },
            { reps: 11, weight: 12.5, rir: 0 },
          ],
        },
        {
          variation: "Machine Lat Pulldown",
          notes: <<~NOTES.squish,
            Grip variation switch from wide to close V-grip. Clean 3x13, ready to progress.
          NOTES
          sets: [
            { reps: 13, weight: 35 },
            { reps: 13, weight: 35 },
            { reps: 13, weight: 35, rir: 0 },
          ],
        },
      ]
    end
  end
end
