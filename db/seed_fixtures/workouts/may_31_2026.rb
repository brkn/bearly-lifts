# frozen_string_literal: true

module Workouts
  class May312026
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
        date: [2026, 5, 31],
        rpe: 8,
        duration_minutes: 50,
        notes: <<~NOTES.squish,
          5.5 hours sleep, a big quality breakfast (potatoes, tomato, avocado, kasar) with a tiny coffee, 5g creatine, and Concerta 54mg beforehand.
          Energy and morning weight not recorded, but output was high throughout.
          Istanbul USA gym.
          Warmed up with 4 minutes on the treadmill at 5.5 km/h, 5 incline, plus 15 warmup-volume lateral raise reps with random pushes before the working lateral raise sets later in the session.
          Tricep Cable Pushdown was added at the end of the session.
          Leg Extension was planned but skipped since the machine was occupied (equipment, not a choice); owed next session.
          Had a little left in the tank at the end, could have fit one more light exercise.
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Standing DB biceps curl",
          notes: <<~NOTES.squish,
            Hit 12 on set 3 this time (vs 10 failed on May 21), but the last 3 reps weren't clean.
            Reps are there at 7.5kg; the truly clean set 3 still isn't.
          NOTES
          sets: [
            { reps: 12, weight: 7.5, rir: 3 },
            { reps: 12, weight: 7.5, rir: 1 },
            { reps: 12, weight: 7.5, rir: 0, notes: "form broke on last 3 reps" },
          ],
        },
        {
          variation: "Incline DB Bench Press",
          notes: <<~NOTES.squish,
            15kg test landed. Overshot the 10-rep target on set 2 and got 12 at 0 RIR.
            Set 3 fell to 8 — viable weight, not yet a 3-set consolidation.
          NOTES
          sets: [
            { reps: 12, weight: 12.5, rir: 1, notes: "opener" },
            { reps: 12, weight: 15, rir: 0 },
            { reps: 8, weight: 15, rir: 0 },
          ],
        },
        {
          variation: "Machine Chest Fly",
          notes: <<~NOTES.squish,
            Pre-fatigue from the incline PR left chest cooked before the flies started.
            Regression vs May 10 (25/30/30), but that day flies went first while fresh; today they came after a hard press to 0 RIR — an order effect, not lost strength.
          NOTES
          sets: [
            { reps: 12, weight: 30, notes: "form broke" },
            { reps: 8, weight: 25, rir: 0 },
            { reps: 10, weight: 25, rir: 0 },
          ],
        },
        {
          variation: "Smith Squat",
          notes: <<~NOTES.squish,
            Sat on the floor after finishing, needed about 4 minutes to recover — a cardiovascular/systemic limiter.
            Beat the 9-rep target with 11/11/11 at the new 17.5kg/side load; all sets taken to failure, but the limiter was conditioning, not leg strength, same pattern as past squat sessions.
          NOTES
          sets: [
            { reps: 11, weight: 17.5, rir: 0 },
            { reps: 11, weight: 17.5, rir: 0 },
            { reps: 11, weight: 17.5, rir: 0 },
          ],
        },
        {
          variation: "Dumbbell Lateral Raise",
          notes: <<~NOTES.squish,
            5kg is clearly submaximal now — many RIR across the board on 12/14/13.
            Form phase can close; ready to load up.
          NOTES
          sets: [
            { reps: 12, weight: 5, notes: "many RIR" },
            { reps: 14, weight: 5, notes: "many RIR" },
            { reps: 13, weight: 5 },
          ],
        },
        {
          variation: "Cable Triceps Pushdown",
          notes: <<~NOTES.squish,
            Added at the end of session on the straight bar attachment.
            30kg working weight confirmed (matches May 16). Set-3 collapse to 6 reps is the end-of-session arm-isolation fade, not a load problem.
          NOTES
          sets: [
            { reps: 13, weight: 25 },
            { reps: 12, weight: 30 },
            { reps: 6, weight: 30, rir: 0 },
          ],
        },
      ]
    end
  end
end
