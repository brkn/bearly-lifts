# frozen_string_literal: true

class EnforceUniqueMuscleNames < ActiveRecord::Migration[8.1]
  def change
    add_index :muscles, :name, unique: true
  end
end
