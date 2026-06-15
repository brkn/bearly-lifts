# frozen_string_literal: true

class SessionsController < ApplicationController
  def index
    @sessions = Session.includes(:muscles).order(date: :desc)
  end

  def show
    @session = Session
               .includes(session_exercises: [:exercise_variation, :workout_sets, :primary_muscle])
               .find(params[:id])
  end
end
