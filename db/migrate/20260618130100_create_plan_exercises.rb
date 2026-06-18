# frozen_string_literal: true

class CreatePlanExercises < ActiveRecord::Migration[8.1]
  def change
    create_table :plan_exercises, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :plan, null: false, foreign_key: true, type: :uuid
      t.references :exercise_variation, null: false, foreign_key: true, type: :uuid
      t.integer :position, null: false
      t.integer :target_sets
      t.integer :target_reps
      t.decimal :target_weight

      t.timestamps
    end

    add_index :plan_exercises, [:plan_id, :position], unique: true
  end
end
