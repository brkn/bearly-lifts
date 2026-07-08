# frozen_string_literal: true

module Workouts
  class January302026
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
        date: [2026, 1, 30],
        rpe: 7,
        duration_minutes: 60,
        notes: <<~NOTES.squish,
          Gym. 8 hours sleep, skipped breakfast (many hours prior), energy 7/10, morning weight not measured, Concerta 54mg plus 1 cup coffee.
          Neck, upper back, and shoulder stiffness noted from coder posture.
          Order as performed, with arms done first as an exercise-order strategy.
          Warmup: ~15-20 minute treadmill.
        NOTES
      }
    end

    def exercises
      [
        {
          variation: "Standing DB biceps curl",
          notes: "First 12/12/12 achieved. Exercise order strategy validated.",
          sets: [
            { reps: 12, weight: 5 },
            { reps: 12, weight: 5 },
            { reps: 12, weight: 5, notes: "last reps shaky, still decent form" },
          ],
        },
        {
          variation: "Cable Triceps Pushdown",
          notes: "Rope attachment. Excellent performance, strong finish on final set.",
          sets: [
            { reps: 14, weight: 20 },
            { reps: 14, weight: 20 },
            { reps: 17, weight: 20, notes: "to exhaustion, good form" },
          ],
        },
        {
          variation: "Smith Squat",
          notes: "Baseline established. Legs have significant capacity remaining.",
          sets: [
            { reps: 12, weight: 2.5, notes: "easy, bar felt bouncy" },
            { reps: 12, weight: 5, notes: "decent, not struggling" },
            { reps: 12, weight: 5, notes: "cardiovascular demand, legs not near failure" },
          ],
        },
        {
          variation: "Machine Chest Fly",
          notes: "Solid baseline at 20kg.",
          sets: [
            { reps: 13, weight: 20 },
            { reps: 12, weight: 20, rir: 4 },
            { reps: 12, weight: 20 },
          ],
        },
        {
          variation: "Incline DB Bench Press",
          notes: <<~NOTES.squish,
            Limiting factor: pre-fatigue from flies, a weight jump, and 10kg dumbbells unavailable.
            Planned flat bench, did incline by mistake.
          NOTES
          sets: [
            { reps: 10, weight: 12.5 },
            { reps: 6, weight: 12.5, rir: 0 },
            { reps: 6, weight: 12.5, rir: 0 },
          ],
        },
        {
          variation: "Seated Cable Row",
          notes: "Consistent and controlled.",
          sets: [
            { reps: 13, weight: 35 },
            { reps: 13, weight: 35 },
            { reps: 13, weight: 35 },
          ],
        },
      ]
    end
  end
end
