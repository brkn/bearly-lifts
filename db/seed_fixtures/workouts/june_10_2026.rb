# frozen_string_literal: true

module Workouts
  class June102026
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
        date: [2026, 6, 10],
        rpe: 7,
        duration_minutes: 50,
        notes: <<~NOTES.squish,
          7 hours sleep, decent breakfast with fruit salad and honey an hour before, energy and morning weight not recorded.
          Istanbul USA gym.
          Order as performed, with biceps and lat pulldown moved early per plan to fix the set-3 curl fade and the buried, unreliable pulldown read.
          Lateral Raise was planned but skipped after the session ended early at 50 minutes.
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Standing DB biceps curl",
          notes: <<~NOTES.squish,
            Done first while fresh, as the controlled test.
            12/12/11 is the best set-3 yet vs June 5's 6 (done last).
            Set 1 only hit 2 RIR, so the jump-to-10kg trigger (3+ RIR) wasn't met — 7.5kg is essentially maxed at this rep scheme.
          NOTES
          sets: [
            { reps: 12, weight: 7.5, rir: 2 },
            { reps: 12, weight: 7.5 },
            { reps: 11, weight: 7.5, rir: 0 },
          ],
        },
        {
          variation: "Incline DB Bench Press",
          notes: <<~NOTES.squish,
            Clean 3x12 — consolidated.
            Progression from June 5 (12/12/10) and May 31 (12/8); 15kg is locked.
          NOTES
          sets: [
            { reps: 12, weight: 15, rir: 2 },
            { reps: 12, weight: 15, rir: 2 },
            { reps: 12, weight: 15, rir: 1, notes: "last few reps shaky but form held" },
          ],
        },
        {
          variation: "Machine Lat Pulldown",
          notes: <<~NOTES.squish,
            The owed clean read — 40kg confirmed.
            Done early/fresh (2nd exercise) vs June 5's unreliable 8/8/10 buried last.
            12/12/12 with sets 2-3 at 0 RIR puts this at the working ceiling.
          NOTES
          sets: [
            { reps: 12, weight: 40, rir: 3 },
            { reps: 12, weight: 40, rir: 0 },
            { reps: 12, weight: 40, rir: 0, notes: "grip/forearm pain became the limiting factor, not lat strength" },
          ],
        },
        {
          variation: "Smith Squat",
          notes: <<~NOTES.squish,
            17.5kg/side consolidated at a clean 3x12.
            Beats June 5 (12/12/11 + void) and May 31 (11/11/11).
            Toes slipping forward in shoes was an equipment issue, not a form issue.
            Ready to test 20kg/side.
          NOTES
          sets: [
            { reps: 12, weight: 17.5, rir: 1 },
            { reps: 12, weight: 17.5, rir: 0 },
            { reps: 12, weight: 17.5, rir: 0,
              notes: "cardiovascular limiter — heart pounding, 3min rest before this set" },
          ],
        },
        {
          variation: "Machine Shoulder Press",
          notes: <<~NOTES.squish,
            Bump from 10kg/side landed but at the edge — 10/9/7, a sharp drop to 0 RIR.
            New working weight, not yet consolidated. Hold here.
          NOTES
          sets: [
            { reps: 10, weight: 12.5, rir: 3 },
            { reps: 9, weight: 12.5, rir: 0 },
            { reps: 7, weight: 12.5, rir: 0 },
          ],
        },
      ]
    end
  end
end
