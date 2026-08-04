# frozen_string_literal: true

class Muscle < ApplicationRecord
  CADENCE_DAYS = 7

  has_many :exercise_muscles, dependent: :destroy
  has_many :exercise_variations, through: :exercise_muscles

  validates :name, presence: true, uniqueness: true

  normalizes :name, with: ->(name) { name.squish.downcase }

  attr_accessor :last_trained_on, :days_since

  def self.gap_ranked(user, today: Date.current)
    last_trained = user.workouts
                       .joins(workout_exercises: { exercise_variation: :exercise_muscles })
                       .group("exercise_muscles.muscle_id")
                       .maximum(:date)

    ranked = all.to_a
    ranked.each { |muscle| muscle.record_gap(last_trained[muscle.id], today) }
    ranked.sort_by { |muscle| [-(muscle.days_since || Float::INFINITY), muscle.name] }
  end

  def slug = name.parameterize

  def label = name.titleize

  def record_gap(last_trained_on, today)
    self.last_trained_on = last_trained_on&.to_date
    self.days_since = self.last_trained_on && (today - self.last_trained_on).to_i
  end

  def overdue?
    return true if days_since.nil?

    days_since > CADENCE_DAYS
  end
end
