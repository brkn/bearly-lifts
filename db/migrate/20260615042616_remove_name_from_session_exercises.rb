# frozen_string_literal: true

class RemoveNameFromSessionExercises < ActiveRecord::Migration[8.1]
  def change
    remove_column :session_exercises, :name, :string, null: false
    change_column_null :session_exercises, :exercise_variation_id, false
  end
end
