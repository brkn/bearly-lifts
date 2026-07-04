# frozen_string_literal: true

class PlansController < ApplicationController
  def new
    @muscles = Current.user.gap_ranked_muscles
  end

  def exercises
    # TODO: use muscle names instead. Url bar is gnarly with many long uuidv7 strings.
    muscle_ids = Array(params[:muscle_ids])

    @muscle_groups = ordered_by_ids(muscle_ids, Current.user.gap_ranked_muscles)
                     .map { |muscle| [muscle, muscle.exercise_variations.to_a] }
  end

  def edit
    @plan = Current.user.plans.current

    redirect_to new_plan_path unless @plan
  end

  def create
    # TODO: "only one plan exists" is enforced ad hoc here (destroy_all + create).
    # Move this invariant into the model (e.g. a Plan.replace! that owns the transaction).
    # Defered until we introduce the user model
    Plan.transaction do
      Current.user.plans.destroy_all

      # TODO: N+1 — variation.suggestion queries workouts/sets per variation.
      # Preload the workout associations so suggestion reads them in memory.
      ordered_exercise_variations = ExerciseVariation.in_order_of(:id, params[:exercise_variation_ids])

      Current.user
             .plans
             .create!
             .create_plan_exercises!(ordered_exercise_variations)
    end

    redirect_to edit_plan_path
  end

  def update
    plan = Current.user.plans.current

    Plan.transaction do
      plan.plan_exercises.each do |pe|
        attrs = params.dig(:plan_exercises, pe.exercise_variation_id.to_s) || {}
        pe.update!(
          target_sets: attrs[:target_sets],
          target_reps: attrs[:target_reps],
          target_weight: attrs[:target_weight].presence,
        )
      end
    end

    redirect_to edit_plan_path
  end

  private

  def ordered_by_ids(ids, records)
    by_id = records.index_by(&:id)
    ids.filter_map { |id| by_id[id] }
  end
end
