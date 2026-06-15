# frozen_string_literal: true

class SessionsController < ApplicationController
  def index
    @sessions = Session.includes(:muscles).order(date: :desc)
  end
end
