# frozen_string_literal: true

class ProgressChart
  class Hero < ProgressChart
    DIMS = { width: 780, height: 300, pad_x: 16, pad_top: 22, pad_bottom: 30, gutter: 34 }.freeze
    GRID_ROWS = 4

    GridRow = Data.define(:y, :label, :label_y)
    DateLabel = Data.define(:text, :x, :anchor)

    delegate :left, :right, to: :geometry

    def partial_path = "progress/charts/hero"
    def css_class = "chart-hero"
    def dot_radius = 4.4
    def stroke_width = 2.4
    def halo_radius = dot_radius + 3
    def axis_label_x = left - 8
    def date_label_y = height - 8

    def grid_rows
      (0..GRID_ROWS).map do |row|
        y = (geometry.top + (geometry.inner_height / GRID_ROWS.to_f * row)).round(1)
        GridRow.new(y: y, label: grid_value(row).round.to_s, label_y: y + 3.5)
      end
    end

    def date_labels
      last = geometry.points.size - 1
      [0, (last / 2.0).round, last].uniq.map do |index|
        DateLabel.new(
          text: geometry.points[index].date.strftime("%b %-d"),
          x: geometry.x_at(index).round(1),
          anchor: { 0 => "start", last => "end" }.fetch(index, "middle"),
        )
      end
    end

    def history_points
      geometry.coords[0...-1].map { |coord| rounded(coord) }
    end

    private

    def grid_value(row)
      geometry.max - ((geometry.max - geometry.min) / GRID_ROWS.to_f * row)
    end
  end
end
