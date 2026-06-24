# frozen_string_literal: true

class AddPositionToWorkoutExerciseSets < ActiveRecord::Migration[8.1]
  def change
    add_column :workout_exercise_sets, :position, :integer, null: false # rubocop:disable Rails/NotNullColumn
    add_index :workout_exercise_sets, [:workout_exercise_id, :position],
              unique: true, name: "index_workout_exercise_sets_on_we_id_and_position"
  end
end
