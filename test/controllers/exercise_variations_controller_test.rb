# frozen_string_literal: true

require "test_helper"

class ExerciseVariationsControllerTest < ActionDispatch::IntegrationTest
  test "index returns matching variations as JSON with name and primary muscle" do
    get exercise_variations_path(q: "row")

    results = response.parsed_body
    expected_result = {
      id: exercise_variations(:seated_cable_rows_default).id,
      name: "Seated Cable Rows",
      muscle: "Back",
    }.stringify_keys

    assert_response :success
    assert_equal 1, results.size
    assert_equal expected_result, results.first
  end

  test "index matches the query case-insensitively" do
    get exercise_variations_path(q: "INcLInE")

    assert_equal(["Incline Dumbbell Press"], response.parsed_body.pluck("name"))
    assert_equal "Chest", response.parsed_body.first["muscle"]
  end

  test "index browses the whole registry in name order when the query is blank" do
    get exercise_variations_path(q: "")

    expected_names = [
      "Dumbbell RDLs",
      "Dumbbell Shoulder Press",
      "Goblet Squat",
      "Incline Dumbbell Press",
      "Lateral Dumbbell Raise",
    ]

    assert_response :success
    assert_equal expected_names, response.parsed_body.first(5).pluck("name")
  end

  test "index caps the browse list at 20 results" do
    Array.new(10) { |i| { exercise: exercises(:goblet_squat), name: "Aaa Variation #{i}" } }
         .then { ExerciseVariation.create!(it) }

    get exercise_variations_path

    assert_response :success
    assert_equal 20, response.parsed_body.size
  end
end
