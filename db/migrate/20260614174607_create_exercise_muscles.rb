# frozen_string_literal: true

class CreateExerciseMuscles < ActiveRecord::Migration[8.1]
  def change
    create_table :exercise_muscles, primary_key: [:session_exercise_id, :muscle_id] do |t|
      t.references :session_exercise, null: false, foreign_key: true, type: :uuid, index: false
      t.references :muscle, null: false, foreign_key: true, type: :uuid
      t.boolean :is_primary, null: false, default: false

      t.timestamps
    end
  end
end
