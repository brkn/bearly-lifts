# frozen_string_literal: true

class PlansController < ApplicationController
  before_action :assign_plan, only: %i[edit update]

  def new
    @muscles = Current.user.gap_ranked_muscles
  end

  def exercises
    @muscle_groups = Current.user
                            .gap_ranked_muscles
                            .in_order_of(:slug, muscle_slugs)
                            .map { |muscle| [muscle, muscle.exercise_variations.to_a] }
  end

  def edit; end

  def create
    # TODO: "only one plan exists" is enforced ad hoc here (destroy_all + create).
    # Move this invariant into the model (e.g. a Plan.replace! that owns the transaction).
    # Defered until we introduce the user model
    Plan.transaction do
      # TODO: the has_one includes scope eager-loads plan_exercises/variations here
      # just to destroy them (~2 wasted queries). Fine on this infrequent action.
      Current.user.plan&.destroy

      # TODO: N+1 — variation.suggestion queries workouts/sets per variation.
      # Preload the workout associations so suggestion reads them in memory.
      ordered_exercise_variations = ExerciseVariation.in_order_of(:id, exercise_variation_ids)

      Current.user
             .create_plan!
             .create_plan_exercises!(ordered_exercise_variations)
    end

    redirect_to edit_plan_path
  end

  def update
    Plan.transaction do
      @plan.plan_exercises.each do |plan_exercise|
        attrs = params.dig(:plan_exercises, plan_exercise.exercise_variation_id.to_s) || {}
        plan_exercise.update!(
          target_sets: attrs[:target_sets],
          target_reps: attrs[:target_reps],
          target_weight: attrs[:target_weight].presence,
        )
      end
    end

    redirect_to edit_plan_path
  end

  private

  def assign_plan
    @plan = Current.user.plan

    redirect_to new_plan_path unless @plan
  end

  def muscle_slugs
    Array(params[:muscles]).flat_map { |value| value.split(",") }
                           .map(&:parameterize)
  end

  def exercise_variation_ids
    Array(params[:exercise_variation_ids])
  end
end
