# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @sessions = Session.includes(:muscles, :session_exercises).order(date: :desc).limit(5)
    @total_count = Session.count
    @month_count = Session.where(date: Date.current.beginning_of_month..).count
  end
end
