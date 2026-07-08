# frozen_string_literal: true

module Workouts
  class May282026
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
        date: [2026, 5, 28],
        rpe: 7,
        duration_minutes: 35,
        notes: <<~NOTES.squish,
          8 hours sleep, a big meal an hour before, energy and morning weight not recorded, no supplements.
          Gym session.
          Warmed up with 2 minutes of treadmill and a warmup set of 20 x 2.5kg lateral dumbbell raises per hand.
          Smith Machine Squats and the lateral raise working sets were planned but not performed.
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Cable Triceps Overhead Extension",
          notes: <<~NOTES.squish,
            Second straight 3x12 at 27.5kg. Matches May 21. Consolidated, not yet earned the bump.
          NOTES
          sets: [
            { reps: 12, weight: 27.5 },
            { reps: 12, weight: 27.5 },
            { reps: 12, weight: 27.5, notes: "shaky" },
          ],
        },
        {
          variation: "Machine Shoulder Press",
          notes: <<~NOTES.squish,
            First time on this machine. 30kg (15kg/side) too heavy — baseline data point, drop load next time.
          NOTES
          sets: [
            { reps: 6, weight: 30, rir: 0, notes: "plate-loaded 15kg/side" },
          ],
        },
        {
          variation: "Machine Rear Delt Fly",
          notes: <<~NOTES.squish,
            Machine. Clean 3x12 with room to spare — ready to progress.
          NOTES
          sets: [
            { reps: 12, weight: 8 },
            { reps: 12, weight: 8 },
            { reps: 12, weight: 8 },
          ],
        },
        {
          variation: "Machine Lat Pulldown",
          notes: <<~NOTES.squish,
            Close V-Grip. First 37.5kg via DB-on-stack workaround.
            Set 2 held clean 12, set 3 dropped to 8. Not consolidated yet — repeat before pushing to 40.
          NOTES
          sets: [
            { reps: 12, weight: 35 },
            { reps: 12, weight: 37.5, notes: "dumbbell-on-stack" },
            { reps: 8, weight: 37.5 },
          ],
        },
        {
          variation: "Seated Cable Row",
          notes: <<~NOTES.squish,
            Consolidating 45kg ceiling from May 10 (13/11/12 at 0 RIR). Two sets — session cut short.
          NOTES
          sets: [
            { reps: 12, weight: 45 },
            { reps: 12, weight: 45 },
          ],
        },
      ]
    end
  end
end
