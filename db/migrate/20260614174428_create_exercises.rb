# frozen_string_literal: true

class CreateExercises < ActiveRecord::Migration[8.1]
  def change
    create_table :exercises, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
  end
end
