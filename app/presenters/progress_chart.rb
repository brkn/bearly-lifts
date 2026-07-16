# frozen_string_literal: true

class ProgressChart
  Point = Data.define(:x, :y)

  VARIANTS = { mini: Mini, rail: Rail, hero: Hero }.freeze

  def self.for(variant)
    VARIANTS.fetch(variant)
  end

  def initialize(lift)
    @lift = lift
    @geometry = Geometry.new(lift.points, self.class::DIMS)
  end

  delegate :width, :height, :line_path, :area_path, to: :geometry
  delegate :tone, to: :lift

  def partial_path = "progress/charts/chart"

  def current_point
    @current_point ||= rounded(geometry.coords.last)
  end

  private

  attr_reader :lift, :geometry

  def rounded(coord)
    Point.new(x: coord[0].round(1), y: coord[1].round(1))
  end
end
