# frozen_string_literal: true

class AddPositionToSessionExercises < ActiveRecord::Migration[8.1]
  def change
    add_column :session_exercises, :position, :integer, null: false
    add_index :session_exercises, [:session_id, :position], unique: true
  end
end
