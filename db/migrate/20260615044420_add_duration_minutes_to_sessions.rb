# frozen_string_literal: true

class AddDurationMinutesToSessions < ActiveRecord::Migration[8.1]
  def change
    add_column :sessions, :duration_minutes, :integer
  end
end
