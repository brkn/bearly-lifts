# frozen_string_literal: true

module Workouts
  class June052026
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
        date: [2026, 6, 5],
        rpe: 8,
        duration_minutes: 80,
        notes: <<~NOTES.squish,
          Great sleep (hours not recorded), great breakfast, high energy, morning weight not recorded.
          ~5-day training gap, legs fully recovered.
          Istanbul USA gym.
          Order as performed, with lat pulldown deferred to the end since the machine was contested all session.
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Seated Cable Row",
          notes: <<~NOTES.squish,
            Clean 3x12 with RIR draining 3→1.
            First full 3-set 45kg in an uninterrupted session — owed sets from May 28 now closed.
          NOTES
          sets: [
            { reps: 12, weight: 45, rir: 3 },
            { reps: 12, weight: 45, rir: 2 },
            { reps: 12, weight: 45, rir: 1 },
          ],
        },
        {
          variation: "Machine Shoulder Press",
          notes: <<~NOTES.squish,
            Super set with the next exercise (Lateral Raise).
            Clean baseline after May 28's 15kg/side failure (6 reps).
            Opening at 4 RIR → 10kg/side is too light.
            Bump next.
          NOTES
          sets: [
            { reps: 12, weight: 10, rir: 4 },
            { reps: 12, weight: 10, rir: 1 },
            { reps: 12, weight: 10, rir: 1 },
          ],
        },
        {
          variation: "Dumbbell Lateral Raise",
          notes: <<~NOTES.squish,
            Super set with the previous exercise (Machine Shoulder Press).
            7.5kg landed but at the edge (11→8 to failure).
            Dropped to 5kg on the last set and dialed in the lowering phase.
            7.5kg is the new working weight, not yet consolidated.
          NOTES
          sets: [
            { reps: 11, weight: 7.5, rir: 0 },
            { reps: 8, weight: 7.5, rir: 0 },
            { reps: 12, weight: 5, rir: 2, notes: "eccentric control much improved" },
          ],
        },
        {
          variation: "Smith Squat",
          notes: <<~NOTES.squish,
            Valid working sets 12/12/11 at 17.5kg/side — beats May 31's 11/11/11.
            Banged shin on an adjacent station between sets (bone bruise); confirmed unrelated to the set-3 form break.
          NOTES
          sets: [
            { reps: 12, weight: 17.5, rir: 1 },
            { reps: 12, weight: 17.5, rir: 0, notes: "load corrected" },
            { reps: 11, weight: 17.5, rir: 0, notes: "form broke on last rep" },
          ],
        },
        {
          variation: "Machine Rear Delt Fly",
          notes: <<~NOTES.squish,
            Heavily submaximal — 14/14/18 with RIR throughout.
            8kg is done.
            Machine jumps 8 → 12kg (no 10kg, no DB-on-stack).
          NOTES
          sets: [
            { reps: 14, weight: 8, rir: 4 },
            { reps: 14, weight: 8, rir: 2 },
            { reps: 18, weight: 8, rir: 3 },
          ],
        },
        {
          variation: "Incline DB Bench Press",
          notes: <<~NOTES.squish,
            Set 3 improved from May 31's 8 → 10.
            Progressing toward a clean 3x12 but not there yet.
            Slotted in early because the lat machine was occupied.
          NOTES
          sets: [
            { reps: 12, weight: 15 },
            { reps: 12, weight: 15, rir: 1 },
            { reps: 10, weight: 15, rir: 0, notes: "bad form on some reps" },
          ],
        },
        {
          variation: "Standing DB biceps curl",
          notes: <<~NOTES.squish,
            Set-3 fade to 6 — the usual end-of-session arm-isolation cascade.
            Reps land at 7.5kg on the fresh sets.
          NOTES
          sets: [
            { reps: 12, weight: 7.5, rir: 2 },
            { reps: 12, weight: 7.5, rir: 0 },
            { reps: 6, weight: 7.5, rir: 0 },
          ],
        },
        {
          variation: "Machine Lat Pulldown",
          notes: <<~NOTES.squish,
            Jumped straight to the 40kg pin (skipped 37.5kg DB-on-stack).
            Landed it at 8/8/10 — but done dead-last on a machine that was busy all session, so this is a fatigued, low-quality read of 40kg.
          NOTES
          sets: [
            { reps: 8, weight: 40 },
            { reps: 8, weight: 40 },
            { reps: 10, weight: 40, rir: 0 },
          ],
        },
      ]
    end
  end
end
