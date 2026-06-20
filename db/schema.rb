# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_20_000000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "exercise_muscles", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "exercise_variation_id", null: false
    t.boolean "is_primary", default: false, null: false
    t.uuid "muscle_id", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_variation_id", "muscle_id"], name: "index_exercise_muscles_on_variation_and_muscle", unique: true
    t.index ["muscle_id"], name: "index_exercise_muscles_on_muscle_id"
  end

  create_table "exercise_variations", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "exercise_id", null: false
    t.boolean "is_default_variation", default: false, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.string "weight_scheme"
    t.index ["exercise_id"], name: "index_exercise_variations_on_exercise_id"
    t.index ["exercise_id"], name: "unique_default_variation", unique: true, where: "is_default_variation"
    t.check_constraint "weight_scheme::text = ANY (ARRAY['per_side'::character varying::text, 'bodyweight'::character varying::text, 'assisted'::character varying::text, 'machine'::character varying::text])", name: "weight_scheme_valid"
  end

  create_table "exercises", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "muscles", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plan_exercises", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "exercise_variation_id", null: false
    t.uuid "plan_id", null: false
    t.integer "position", null: false
    t.integer "target_reps"
    t.integer "target_sets"
    t.decimal "target_weight"
    t.datetime "updated_at", null: false
    t.index ["exercise_variation_id"], name: "index_plan_exercises_on_exercise_variation_id"
    t.index ["plan_id", "position"], name: "index_plan_exercises_on_plan_id_and_position", unique: true
    t.index ["plan_id"], name: "index_plan_exercises_on_plan_id"
  end

  create_table "plans", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workout_exercises", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "exercise_variation_id", null: false
    t.text "notes"
    t.integer "position", null: false
    t.uuid "workout_id", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_variation_id"], name: "index_workout_exercises_on_exercise_variation_id"
    t.index ["workout_id", "position"], name: "index_workout_exercises_on_workout_id_and_position", unique: true
    t.index ["workout_id"], name: "index_workout_exercises_on_workout_id"
  end

  create_table "workouts", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "date", default: -> { "now()" }
    t.integer "duration_minutes"
    t.text "notes"
    t.integer "rpe", null: false
    t.datetime "updated_at", null: false
    t.check_constraint "rpe >= 1 AND rpe <= 10", name: "rpe_between_1_and_10"
  end

  create_table "workout_exercise_sets", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "notes"
    t.integer "reps", null: false
    t.integer "rir"
    t.uuid "workout_exercise_id", null: false
    t.datetime "updated_at", null: false
    t.decimal "weight", null: false
    t.index ["workout_exercise_id"], name: "index_workout_exercise_sets_on_workout_exercise_id"
    t.check_constraint "rir >= 0", name: "rir_non_negative"
  end

  add_foreign_key "exercise_muscles", "exercise_variations"
  add_foreign_key "exercise_muscles", "muscles"
  add_foreign_key "exercise_variations", "exercises"
  add_foreign_key "plan_exercises", "exercise_variations"
  add_foreign_key "plan_exercises", "plans"
  add_foreign_key "workout_exercises", "exercise_variations"
  add_foreign_key "workout_exercises", "workouts"
  add_foreign_key "workout_exercise_sets", "workout_exercises"
end
