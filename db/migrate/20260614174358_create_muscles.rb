# frozen_string_literal: true

class CreateMuscles < ActiveRecord::Migration[8.1]
  def change
    create_table :muscles, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
