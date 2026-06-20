# frozen_string_literal: true

class PlansController < ApplicationController
  def show
    @plan = Plan.current
  end

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

  def review
    variation_ids = Array(params[:exercise_variation_ids])
    by_id = ExerciseVariation.where(id: variation_ids).index_by(&:id)
    @variations = variation_ids.filter_map { |id| by_id[id] }
  end

  def create
    variation_ids = Array(params[:exercise_variation_ids])

    Plan.transaction do
      Plan.destroy_all
      plan = Plan.create!
      variation_ids.each_with_index { |vid, idx| plan.plan_exercises.create!(exercise_attrs(vid, idx)) }
    end

    # TODO: reset/delete flow
    redirect_to plan_path
  end

  private

  def exercise_attrs(vid, idx)
    pe = params.dig(:plan_exercises, vid) || {}
    {
      exercise_variation_id: vid,
      position: idx + 1,
      target_sets: pe[:target_sets],
      target_reps: pe[:target_reps],
      target_weight: pe[:target_weight].presence,
    }
  end
end
