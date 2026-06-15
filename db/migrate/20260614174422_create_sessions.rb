# frozen_string_literal: true

class CreateSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :sessions, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.datetime :date, default: -> { "now()" }
      t.integer :rpe, null: false
      t.text :notes

      t.timestamps
    end

    add_check_constraint :sessions, "rpe BETWEEN 1 AND 10", name: "rpe_between_1_and_10"
  end
end
