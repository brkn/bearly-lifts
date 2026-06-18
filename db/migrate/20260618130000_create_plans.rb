# frozen_string_literal: true

class CreatePlans < ActiveRecord::Migration[8.1]
  def change
    create_table :plans, id: :uuid, default: -> { "uuidv7()" }, &:timestamps
  end
end
