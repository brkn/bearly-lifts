# frozen_string_literal: true

class SessionsController < ApplicationController
  def index
    @sessions = Session.includes(:muscles).order(date: :desc)
  end

  def show
    @session = Session
               .includes(:muscles, session_exercises: [:exercise_variation, :workout_sets])
               .find(params[:id])
  end
end
