# frozen_string_literal: true

class SeedExercisesWithVariations
  # NOTE: First variation is always the default variation
  DEFINITIONS = [
    {
      name: "Seated Cable Row",
      variations: [
        { name: "Seated Cable Row", weight_scheme: "machine" },
      ],
    },
    {
      name: "Shoulder Press",
      variations: [
        { name: "Machine Shoulder Press", weight_scheme: "machine" },
        { name: "Dumbbell Shoulder Press", weight_scheme: "per_side" },
      ],
    },
    {
      name: "Lateral Raise",
      variations: [
        { name: "Dumbbell Lateral Raise", weight_scheme: "per_side" },
      ],
    },
    {
      name: "Squat",
      variations: [
        { name: "Smith Squat", weight_scheme: "per_side" },
        # TODO: we need a migration to fix this. Goblet is a single weight
        { name: "Goblet Squat", weight_scheme: "per_side" },
      ],
    },
    {
      name: "Rear Delt Fly",
      variations: [
        { name: "Machine Rear Delt Fly", weight_scheme: "machine" },
        { name: "Dumbbell Rear Delt Fly", weight_scheme: "per_side" },
      ],
    },
    {
      name: "Incline Bench Press",
      variations: [
        { name: "Incline DB Bench Press", weight_scheme: "per_side" },
      ],
    },
    {
      name: "Biceps Curl",
      variations: [
        { name: "Standing DB biceps curl", weight_scheme: "per_side" },
        { name: "Preacher Curl", weight_scheme: "per_side" },
        { name: "Hammer Curls", weight_scheme: "per_side" },
      ],
    },
    {
      name: "Lat Pulldown",
      variations: [
        { name: "Machine Lat Pulldown", weight_scheme: "machine" },
      ],
    },
    {
      name: "Chest Fly",
      variations: [
        { name: "Machine Chest Fly", weight_scheme: "machine" },
        { name: "DB Chest Fly", weight_scheme: "per_side" },
      ],
    },
    {
      name: "Triceps Pushdown",
      variations: [
        { name: "Cable Triceps Pushdown", weight_scheme: "machine" },
      ],
    },
    {
      name: "Triceps Extension",
      variations: [
        { name: "Cable Triceps Overhead Extension", weight_scheme: "machine" },
      ],
    },
    {
      name: "Romanian Deadlift",
      variations: [
        { name: "Dumbbell Romanian Deadlift", weight_scheme: "per_side" },
      ],
    },
    {
      name: "Leg Extension",
      variations: [
        { name: "Machine Leg Extension", weight_scheme: "machine" },
      ],
    },
    {
      name: "Flat Bench Press",
      variations: [
        { name: "Flat DB Bench Press", weight_scheme: "per_side" },
      ],
    },
    {
      name: "Skull Crusher",
      variations: [
        { name: "Dumbbell Skull Crusher", weight_scheme: "per_side" },
      ],
    },
    {
      name: "Lunge",
      variations: [
        { name: "Lunges", weight_scheme: "per_side" },
      ],
    },
    {
      name: "Shrug",
      variations: [
        { name: "Shrugs", weight_scheme: "per_side" },
      ],
    },
    {
      name: "Neck Push",
      variations: [
        { name: "Neck Pushes (Dumbbell Assisted)", weight_scheme: "per_side" },
      ],
    },
    {
      name: "Neck Extension",
      variations: [
        { name: "Neck Extensions (Prone)", weight_scheme: "bodyweight" },
      ],
    },
    {
      name: "Russian Twist",
      variations: [
        { name: "Russian Twists", weight_scheme: "per_side" },
      ],
    },
    {
      name: "Chin-up",
      variations: [
        { name: "Assisted Chin-ups", weight_scheme: "assisted" },
      ],
    },
    {
      name: "Dip",
      variations: [
        { name: "Assisted Dips", weight_scheme: "assisted" },
      ],
    },
    {
      name: "Standing Leg Raise",
      variations: [
        { name: "Standing Leg Raises", weight_scheme: "bodyweight" },
      ],
    },
  ].freeze

  def self.seed!
    return if ExerciseVariation.exists?

    DEFINITIONS.each do |definition|
      attributes_list = definition[:variations].each_with_index.map do |variation, index|
        variation.slice(:name, :weight_scheme)
                 .merge(is_default_variation: index.zero?)
      end

      Exercise.create!(name: definition[:name])
              .exercise_variations.create!(attributes_list)
    end
  end
end
