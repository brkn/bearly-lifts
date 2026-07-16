# frozen_string_literal: true

class ProgressChart
  class Geometry
    attr_reader :points, :dims

    def initialize(points, dims)
      @points = points
      @dims = dims
    end

    def width = dims[:width]
    def height = dims[:height]
    def left = dims[:pad_x] + dims.fetch(:gutter, 0)
    def right = width - dims[:pad_x]
    def top = dims[:pad_top]
    def bottom = height - dims[:pad_bottom]
    def inner_width = right - left
    def inner_height = bottom - top

    def min
      @min ||= values.min
    end

    def max
      @max ||= values.max
    end

    def range
      @range ||= (max - min).then { |spread| spread.zero? ? 1.0 : spread }
    end

    def x_at(index)
      return left + (inner_width / 2.0) if points.one?

      left + (index.to_f / (points.size - 1) * inner_width)
    end

    def y_at(value)
      top + inner_height - ((value - min) / range * inner_height)
    end

    def coords
      @coords ||= values.each_with_index.map { |value, index| [x_at(index), y_at(value)] }
    end

    def line_path
      @line_path ||= coords.each_with_index
                           .map { |(x, y), index| "#{index.zero? ? 'M' : 'L'}#{x.round(1)} #{y.round(1)}" }
                           .join(" ")
    end

    def area_path
      "#{line_path} L #{coords.last.first.round(1)} #{bottom} L #{coords.first.first.round(1)} #{bottom} Z"
    end

    private

    def values
      @values ||= points.map { |point| point.weight.to_f }
    end
  end
end
