# frozen_string_literal: true

class SeedExerciseMuscles
  DEFINITIONS = [
    { variation: "Seated Cable Row", muscle: "Back" },
    { variation: "Machine Shoulder Press", muscle: "Shoulders" },
    { variation: "Dumbbell Shoulder Press", muscle: "Shoulders" },
    { variation: "Dumbbell Lateral Raise", muscle: "Shoulders" },
    { variation: "Smith Squat", muscle: "Legs" },
    { variation: "Goblet Squat", muscle: "Legs" },
    { variation: "Machine Rear Delt Fly", muscle: "Shoulders" },
    { variation: "Incline DB Bench Press", muscle: "Chest" },
    { variation: "Standing DB biceps curl", muscle: "Arms" },
    { variation: "Machine Lat Pulldown", muscle: "Back" },
    { variation: "Machine Chest Fly", muscle: "Chest" },
    { variation: "Cable Triceps Pushdown", muscle: "Arms" },
    { variation: "Cable Triceps Overhead Extension", muscle: "Arms" },
    { variation: "Dumbbell Romanian Deadlift", muscle: "Legs" },
    { variation: "Machine Leg Extension", muscle: "Legs" },
    { variation: "Flat DB Bench Press", muscle: "Chest" },
    { variation: "Dumbbell Skull Crusher", muscle: "Arms" },
    { variation: "Lunges", muscle: "Legs" },
    { variation: "DB Chest Fly", muscle: "Chest" },
    { variation: "Shrugs", muscle: "Shoulders" },
    { variation: "Neck Pushes (Dumbbell Assisted)", muscle: "Neck" },
    { variation: "Neck Extensions (Prone)", muscle: "Neck" },
    { variation: "Russian Twists", muscle: "Core" },
    { variation: "Assisted Chin-ups", muscle: "Back" },
    { variation: "Assisted Dips", muscle: "Chest" },
    { variation: "Preacher Curl", muscle: "Arms" },
    { variation: "Hammer Curls", muscle: "Arms" },
    { variation: "Standing Leg Raises", muscle: "Core" },
    { variation: "Dumbbell Rear Delt Fly", muscle: "Shoulders" },
  ].freeze

  def self.seed!
    return if ExerciseMuscle.exists?

    DEFINITIONS.each do |definition|
      variation = ExerciseVariation.find_by!(name: definition[:variation])
      muscle = Muscle.find_by!(name: definition[:muscle])

      variation.exercise_muscles.create!(muscle:, is_primary: true)
    end
  end
end
