# frozen_string_literal: true

class LiftProgress
  Point = Data.define(:date, :weight, :reps, :rir, :sets_count)

  TONES = { progress: "up", hold: "stall", rebase: "cold" }.freeze

  def self.for_all
    # TODO: No sorting/ordering applied atm.
    # # We should add worst-first ordering (rebase, then hold, then progress; most days idle first).
    ExerciseVariation
      .joins(:workout_exercises)
      .distinct
      .includes(:primary_muscle, workout_exercises: [:workout, :workout_exercise_sets])
      .map { |variation| new(variation) }
      .reject { |lift| lift.points.empty? }
  end

  def initialize(variation)
    @variation = variation
  end

  attr_reader :variation

  delegate :id, :name, :weight_scheme, to: :variation

  def muscle_name
    variation.primary_muscle&.name
  end

  def points
    @points ||= logged_exercises.map { |workout_exercise| best_point(workout_exercise) }
  end

  def suggestion
    @suggestion ||= Suggestion.from(
      logged_exercises.last.workout_exercise_sets.to_a,
      performed_on: last_date,
      today: Date.current,
    )
  end

  def tone
    TONES.fetch(suggestion.trend)
  end

  def presenter
    @presenter ||= LiftProgressPresenter.new(self)
  end

  def verdict
    # TODO: LLM-generated coach verdict from the lift history.
    "Coach's read on this lift lands here soon."
  end

  def current_weight = points.last.weight
  def current_reps = points.last.reps
  def top_weight = points.map(&:weight).max
  def delta_weight = current_weight - points.first.weight
  def workouts_count = points.size
  def first_date = points.first.date
  def last_date = points.last.date
  def days_idle = (Date.current - last_date).to_i

  private

  def logged_exercises
    @logged_exercises ||= variation.workout_exercises
                                   .reject { |workout_exercise| workout_exercise.workout_exercise_sets.empty? }
                                   .sort_by { |workout_exercise| workout_exercise.workout.date }
  end

  def best_point(workout_exercise)
    sets = workout_exercise.workout_exercise_sets
    best = sets.max_by { |set| [set.weight, set.reps] }

    Point.new(
      date: workout_exercise.workout.date.to_date,
      weight: best.weight,
      reps: best.reps,
      rir: best.rir,
      sets_count: sets.size,
    )
  end
end
