# frozen_string_literal: true

class ProgressController < ApplicationController
  before_action :assign_lifts
  before_action :assign_lift, only: :show

  def index
    @tone_counts = @lifts.map(&:tone).tally
  end

  def show; end

  private

  def assign_lifts
    @lifts = LiftProgress.for_all
  end

  def assign_lift
    @lift = @lifts.find { |lift| lift.id == lift_id }

    raise ActiveRecord::RecordNotFound, "no logged lift #{lift_id}" unless @lift
  end

  def lift_id
    @lift_id ||= params.expect(:id)
  end
end
