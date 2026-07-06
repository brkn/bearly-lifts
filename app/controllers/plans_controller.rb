# frozen_string_literal: true

class PlansController < ApplicationController
  before_action :assign_plan, only: %i[edit update]

  def new
    @muscles = Current.user.gap_ranked_muscles
  end

  def exercises
    # TODO: use muscle names instead. Url bar is gnarly with many long uuidv7 strings.
    muscle_ids = Array(params[:muscle_ids])

    @muscle_groups = ordered_by_ids(muscle_ids, Current.user.gap_ranked_muscles)
                     .map { |muscle| [muscle, muscle.exercise_variations.to_a] }
  end

  def edit; end

  def create
    # TODO: "only one plan exists" is enforced ad hoc here (destroy_all + create).
    # Move this invariant into the model (e.g. a Plan.replace! that owns the transaction).
    # Defered until we introduce the user model
    Plan.transaction do
      Current.user.plans.destroy_all

      # TODO: N+1 — variation.suggestion queries workouts/sets per variation.
      # Preload the workout associations so suggestion reads them in memory.
      ordered_exercise_variations = ExerciseVariation.in_order_of(:id, exercise_variation_ids)

      Current.user
             .plans
             .create!
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

  # TODO: delete this method infavor of using `#in_order_of` method.
  # # `Current.user.gap_ranked_muscles.in_order_of(:id, muscle_ids)`
  def ordered_by_ids(ids, records)
    by_id = records.index_by(&:id)
    ids.filter_map { |id| by_id[id] }
  end

  def exercise_variation_ids
    Array(params[:exercise_variation_ids])
  end
end
