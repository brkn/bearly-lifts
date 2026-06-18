# frozen_string_literal: true

class MoveExerciseMusclesToVariations < ActiveRecord::Migration[8.1]
  def up
    drop_table :exercise_muscles

    create_table :exercise_muscles, id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
      t.uuid :exercise_variation_id, null: false
      t.uuid :muscle_id, null: false
      t.boolean :is_primary, default: false, null: false
      t.timestamps
      t.index [:exercise_variation_id, :muscle_id], unique: true, name: "index_exercise_muscles_on_variation_and_muscle"
      t.index :muscle_id
    end

    add_foreign_key :exercise_muscles, :exercise_variations
    add_foreign_key :exercise_muscles, :muscles
  end

  def down
    drop_table :exercise_muscles

    create_table :exercise_muscles, primary_key: [:session_exercise_id, :muscle_id], force: :cascade do |t|
      t.uuid :session_exercise_id, null: false
      t.uuid :muscle_id, null: false
      t.boolean :is_primary, default: false, null: false
      t.timestamps
      t.index :muscle_id
    end

    add_foreign_key :exercise_muscles, :session_exercises
    add_foreign_key :exercise_muscles, :muscles
  end
end
