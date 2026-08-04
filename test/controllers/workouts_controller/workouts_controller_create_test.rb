# frozen_string_literal: true

require "test_helper"

class WorkoutsControllerCreateTest < ActionDispatch::IntegrationTest
  def setup
    sign_in_as(users(:one))
    @incline = exercise_variations(:incline_press_default)
    @rows = exercise_variations(:seated_cable_rows_default)
  end

  test "inserts the workout with its relations and redirects to the workout" do
    payload = workout_payload(rpe: 8, notes: "felt strong")

    assert_difference("Workout.count" => 1, "WorkoutExercise.count" => 2, "WorkoutExerciseSet.count" => 4) do
      post workouts_path, params: payload
    end

    assert_response :redirect
  end

  test "creates the workout with correct attributes" do
    payload = workout_payload(rpe: 8, notes: "felt strong")

    post workouts_path, params: payload

    workout = Workout.last
    positions = workout.workout_exercises.order(:position).map { |we| [we.position, we.exercise_variation_id] }
    expected_workout_attributes = { rpe: 8, notes: "felt strong" }

    assert_equal expected_workout_attributes, workout.attributes.symbolize_keys.slice(:rpe, :notes)
    assert_predicate workout.date, :present?, "expected the DB default to fill date"
    assert_equal [[1, @incline.id], [2, @rows.id]], positions
  end

  test "created sets are assigned a position by the array index order" do
    post workouts_path, params: workout_payload

    sets = Workout.last.workout_exercises.order(:position).first.workout_exercise_sets.order(:position)

    assert_equal([[1, 10], [2, 8], [3, 7]], sets.map { |s| [s.position, s.reps] })
  end

  test "create coerces a blank rir to nil but keeps an explicit zero" do
    post workouts_path, params: workout_payload

    sets = Workout.last.workout_exercises.first.workout_exercise_sets

    assert_nil sets.find { |s| s.reps == 10 }.rir
    assert_equal 0, sets.find { |s| s.reps == 8 }.rir
  end

  test "create coerces blank notes to nil on the workout and its sets" do
    post workouts_path, params: workout_payload(notes: "")
    workout = Workout.last

    assert_nil workout.notes
    assert_nil workout.workout_exercises.first.workout_exercise_sets.first.notes
  end

  test "create persists exercise notes and coerces blank notes to nil" do
    post workouts_path, params: workout_payload
    created_exercises = Workout.last.workout_exercises.order(:position)

    assert_nil created_exercises.first.notes
    assert_equal "top set heavy", created_exercises.second.notes
  end

  test "create with a missing rpe saves nothing and responds 422" do
    exercises = [
      { exercise_variation_id: @incline.id, workout_exercise_sets: [{ reps: 10, weight: 20 }] },
    ]

    assert_no_difference(["Workout.count", "WorkoutExercise.count", "WorkoutExerciseSet.count"]) do
      post workouts_path, params: workout_payload(rpe: nil, exercises: exercises)
    end

    assert_response :unprocessable_content
  end

  test "create rolls back the entire tree when a set is missing its weight" do
    exercises = [
      {
        exercise_variation_id: @incline.id,
        workout_exercise_sets: [
          { reps: 10, weight: 20 },
          { reps: 8, weight: "" },
        ],
      },
    ]

    assert_no_difference(["Workout.count", "WorkoutExercise.count", "WorkoutExerciseSet.count"]) do
      post workouts_path, params: workout_payload(exercises: exercises)
    end

    assert_response :unprocessable_content
  end

  private

  def workout_payload(rpe: 7, notes: nil, exercises: nil)
    {
      workout: {
        rpe: rpe,
        notes: notes,
        workout_exercises: exercises.presence || default_exercises_payload,
      },
    }
  end

  def default_exercises_payload
    @default_exercises_payload ||= [
      {
        exercise_variation_id: @incline.id,
        notes: "",
        workout_exercise_sets: [
          { reps: 10, weight: 20, rir: "", notes: "" },
          { reps: 8, weight: 22, rir: "0" },
          { reps: 7, weight: 25, rir: 0 },
        ],
      },
      {
        exercise_variation_id: @rows.id, notes: "top set heavy",
        workout_exercise_sets: [{ reps: 12, weight: 50 }],
      },
    ]
  end
end
