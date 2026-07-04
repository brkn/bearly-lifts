# frozen_string_literal: true

class ExerciseVariation < ApplicationRecord
  belongs_to :exercise

  has_many :workout_exercises, dependent: :restrict_with_exception
  has_many :exercise_muscles, dependent: :destroy
  has_many :muscles, through: :exercise_muscles

  has_one :primary_exercise_muscle,
          -> { where(is_primary: true) },
          class_name: "ExerciseMuscle",
          inverse_of: :exercise_variation
  has_one :primary_muscle,
          through: :primary_exercise_muscle,
          source: :muscle

  enum :weight_scheme, {
    per_side: "per_side",
    bodyweight: "bodyweight",
    assisted: "assisted",
    machine: "machine",
  }

  scope :name_matching, lambda { |query|
    query.blank? ? order(:name) : where("name ILIKE ?", "%#{sanitize_sql_like(query)}%").order(:name)
  }

  validates :name, presence: true
  validates :exercise_id,
            uniqueness: { conditions: -> { where(is_default_variation: true) } },
            if: :is_default_variation

  def suggestion(user)
    last_workout_exercise = user.workout_exercises
                                .where(exercise_variation: self)
                                .order("workouts.date DESC")
                                .first

    return Suggestion.new_rebase_suggestion if last_workout_exercise.nil?

    Suggestion.from(
      last_workout_exercise.workout_exercise_sets.to_a,
      performed_on: last_workout_exercise.workout.date.to_date,
      today: Date.current,
    )
  end
end
