# frozen_string_literal: true

module Workouts
  class April292026
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
        date: [2026, 4, 29],
        rpe: 7,
        duration_minutes: 50,
        notes: <<~NOTES.squish,
          Good sleep (hours not recorded), fasted going in, energy started solid but crashed mid-session, morning weight not measured, 300ml coffee.
          At the gym.
          Warmed up with 10:30 minutes on the treadmill at 5.8 km/h, incline 6.
          Walked 15 minutes home after.
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Dumbbell Lateral Raise",
          notes: <<~NOTES.squish,
            First post-comeback work at 5kg.
          NOTES
          sets: [
            { reps: 17, weight: 2.5, notes: "many RIR" },
            { reps: 17, weight: 2.5, notes: "many RIR" },
            { reps: 14, weight: 5, rir: 2 },
          ],
        },
        {
          variation: "Standing DB biceps curl",
          notes: <<~NOTES.squish,
            First clean 12/12/12 with RIR remaining post-comeback.
            Considering preacher curl variation.
          NOTES
          sets: [
            { reps: 12, weight: 5, rir: 3 },
            { reps: 12, weight: 5, rir: 2 },
            { reps: 12, weight: 5, rir: 1 },
          ],
        },
        {
          variation: "Dumbbell Romanian Deadlift",
          notes: <<~NOTES.squish,
            Super set with the next exercise (Tricep Overhead Cable Extension).
            First proper-load RDL session at gym.
            Right lower back held up fine.
          NOTES
          sets: [
            { reps: 14, weight: 15 },
            { reps: 13, weight: 15, rir: 3 },
            { reps: 11, weight: 17.5, rir: 2 },
          ],
        },
        {
          variation: "Cable Triceps Overhead Extension",
          notes: <<~NOTES.squish,
            Super set with the previous exercise (Dumbbell RDLs).
            Stance was standing, back to machine, pulling from above head with slight forward lean.
            Arm tingling at 25kg. Possible nerve compression at end range. Watch.
          NOTES
          sets: [
            { reps: 13, weight: 20, rir: 2 },
            { reps: 9, weight: 25, rir: 1, notes: "RPE 8, tingles in arm" },
            { reps: 13, weight: 20, rir: 1 },
          ],
        },
        {
          variation: "Smith Squat",
          notes: <<~NOTES.squish,
            Limiting factor was blood sugar crashing; laid down to recover.
          NOTES
          sets: [
            { reps: 13, weight: 10, rir: 4, notes: "bar weight excluded" },
            { reps: 13, weight: 15, rir: 1 },
            { reps: 14, weight: 15, rir: 0 },
          ],
        },
        {
          variation: "Machine Lat Pulldown",
          notes: <<~NOTES.squish,
            Limiting factor was dizziness from the blood sugar drop, not muscular; cut the session here.
          NOTES
          sets: [
            { reps: 15, weight: 30 },
            { reps: 12, weight: 30 },
          ],
        },
      ]
    end
  end
end
