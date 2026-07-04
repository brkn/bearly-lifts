# frozen_string_literal: true

class AddUserToWorkoutsAndPlans < ActiveRecord::Migration[8.1]
  def change
    add_reference :workouts, :user, type: :uuid, null: false, foreign_key: { on_delete: :restrict }
    add_reference :plans, :user, type: :uuid, null: false, foreign_key: { on_delete: :restrict }
  end
end
