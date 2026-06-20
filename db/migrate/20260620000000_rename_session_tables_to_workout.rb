# frozen_string_literal: true

class RenameSessionTablesToWorkout < ActiveRecord::Migration[8.1]
  def change
    rename_table :sessions, :workouts
    rename_column :session_exercises, :session_id, :workout_id
    rename_table :session_exercises, :workout_exercises
    rename_column :workout_sets, :session_exercise_id, :workout_exercise_id
    rename_table :workout_sets, :workout_exercise_sets
  end
end
