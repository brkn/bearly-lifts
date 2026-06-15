# frozen_string_literal: true

class CreateSessionExercises < ActiveRecord::Migration[8.1]
  def change
    create_table :session_exercises, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :session, null: false, foreign_key: true, type: :uuid
      t.references :exercise_variation, null: true, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.text :notes

      t.timestamps
    end
  end
end
