# frozen_string_literal: true

class ExerciseVariationsController < ApplicationController
  MAX_RESULTS = 20

  def index
    variations = ExerciseVariation.includes(:primary_muscle)
                                  .name_matching(params[:q])
                                  .limit(MAX_RESULTS)
                                  .map do |variation|
                                    {
                                      id: variation.id,
                                      name: variation.name,
                                      muscle: variation.primary_muscle&.name,
                                      weight_scheme: variation.weight_scheme,
                                    }
                                  end

    render json: variations
  end
end
