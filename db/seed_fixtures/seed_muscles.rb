# frozen_string_literal: true

class SeedMuscles
  NAMES = %w[back shoulders legs chest arms neck core].freeze

  def self.seed!
    NAMES.map { |name| Muscle.find_or_create_by!(name: name) }
  end
end
