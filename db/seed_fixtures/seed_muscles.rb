# frozen_string_literal: true

class SeedMuscles
  NAMES = %w[Back Shoulders Legs Chest Arms Neck Core].freeze

  def self.seed!
    NAMES.map { |name| Muscle.find_or_create_by!(name: name) }
  end
end
