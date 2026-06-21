# frozen_string_literal: true

class PlansController < ApplicationController
  def new
    @muscles = Muscle.gap_ranked
  end

  def exercises
    muscle_ids = Array(params[:muscle_ids])
    ranked = Muscle.gap_ranked
    by_id  = ranked.index_by(&:id)

    @muscle_groups = muscle_ids.filter_map { |id| by_id[id] }
                               .map { |muscle| [muscle, muscle.exercise_variations.to_a] }
  end

  def edit
    @plan = Plan.current
    redirect_to(new_plan_path) unless @plan
  end

  def create
    Plan.transaction do
      Plan.destroy_all
      plan = Plan.create!

      submitted_exercise_variations.each_with_index do |variation, idx|
        plan.plan_exercises.create!(
          exercise_variation: variation,
          position: idx + 1,
          target_sets: variation.suggestion.sets || 3,
          target_reps: variation.suggestion.reps || 8,
          target_weight: variation.suggestion.weight,
        )
      end
    end

    redirect_to edit_plan_path
  end

  def update
    plan = Plan.current

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

  # TODO: consider adding a method like this for the #exercises action
  # def submitted_muscles

  def submitted_exercise_variations
    variation_ids = Array(params[:exercise_variation_ids])
    by_id = ExerciseVariation.where(id: variation_ids).index_by(&:id)

    variation_ids.filter_map { |id| by_id[id] }
  end
end
