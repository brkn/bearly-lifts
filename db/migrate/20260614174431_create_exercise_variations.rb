# frozen_string_literal: true

class CreateExerciseVariations < ActiveRecord::Migration[8.1]
  def change
    create_table :exercise_variations, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :exercise, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.boolean :is_default_variation, null: false, default: false
      t.string :weight_scheme

      t.timestamps
    end

    add_index :exercise_variations, :exercise_id,
              unique: true,
              where: "is_default_variation",
              name: "unique_default_variation"

    add_check_constraint :exercise_variations,
                         "weight_scheme IN ('per_side', 'bodyweight', 'assisted', 'machine')",
                         name: "weight_scheme_valid"
  end
end
