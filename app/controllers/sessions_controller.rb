# frozen_string_literal: true

class SessionsController < ApplicationController
  def index
    @sessions = Session.includes(:muscles, :session_exercises).order(date: :desc)
    @total_count = @sessions.size
    @month_count = @sessions.count { |s| s.date >= Date.current.beginning_of_month }
  end

  def show
    @session = Session
               .includes(:muscles, session_exercises: [:exercise_variation, :workout_sets])
               .find(params[:id])
  end
end
