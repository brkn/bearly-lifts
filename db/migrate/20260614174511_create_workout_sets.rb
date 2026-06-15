# frozen_string_literal: true

class CreateWorkoutSets < ActiveRecord::Migration[8.1]
  def change
    create_table :workout_sets, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :session_exercise, null: false, foreign_key: true, type: :uuid
      t.decimal :weight, null: false
      t.integer :reps, null: false
      t.integer :rir
      t.text :notes

      t.timestamps
    end

    add_check_constraint :workout_sets, "rir >= 0", name: "rir_non_negative"
  end
end
