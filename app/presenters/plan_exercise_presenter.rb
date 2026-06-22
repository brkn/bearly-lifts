# frozen_string_literal: true

class PlanExercisePresenter
  def initialize(plan_exercise)
    @plan_exercise = plan_exercise
  end

  def input_name(field)
    "plan_exercises[#{@plan_exercise.exercise_variation_id}][#{field}]"
  end
end
