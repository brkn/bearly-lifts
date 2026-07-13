# frozen_string_literal: true

class EnforceOnePlanPerUser < ActiveRecord::Migration[8.1]
  def change
    remove_index :plans, :user_id
    add_index :plans, :user_id, unique: true
  end
end
