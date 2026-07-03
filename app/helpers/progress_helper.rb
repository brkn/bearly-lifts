# frozen_string_literal: true

module ProgressHelper
  CHART_DIMS = {
    mini: { width: 200, height: 62, pad_x: 4, pad_top: 8, pad_bottom: 8 },
    rail: { width: 88, height: 30, pad_x: 3, pad_top: 5, pad_bottom: 5 },
    hero: { width: 780, height: 300, pad_x: 16, pad_top: 22, pad_bottom: 30 },
  }.freeze

  GRID_ROWS = 4
  CURRENT_DOT_RADIUS = { mini: 3.2, rail: 2.6, hero: 4.4 }.freeze

  def progress_chart(lift, variant:)
    geometry = ChartGeometry.new(lift.points, CHART_DIMS.fetch(variant), axis: variant == :hero)

    parts = []
    parts << chart_grid(geometry) if variant == :hero
    parts << chart_series(geometry)
    parts << chart_history_dots(geometry) if variant == :hero
    parts << chart_current_dot(geometry, variant)

    chart_svg(geometry, variant, lift.tone, safe_join(parts))
  end

  private

  def chart_svg(geometry, variant, tone, content)
    attrs = {
      viewBox: "0 0 #{geometry.width} #{geometry.height}",
      class: "chart-svg chart-#{variant} #{tone}",
    }
    if variant == :hero
      attrs[:style] = "width:100%;height:auto;"
    else
      attrs[:width] = geometry.width
      attrs[:height] = geometry.height
    end

    tag.svg(content, **attrs)
  end

  def chart_series(geometry)
    area = tag.path(d: geometry.area_path, fill: "currentColor", "fill-opacity": 0.12, stroke: "none")
    line = tag.path(
      d: geometry.line_path, fill: "none", stroke: "currentColor",
      "stroke-width": geometry.width > 100 ? 2.4 : 1.8,
      "stroke-linejoin": "round", "stroke-linecap": "round",
    )

    safe_join([area, line])
  end

  def chart_grid(geometry)
    rows = (0..GRID_ROWS).map { |row| chart_grid_row(geometry, row) }
    safe_join(rows + chart_date_labels(geometry))
  end

  def chart_grid_row(geometry, row)
    row_y = (geometry.top + (geometry.inner_height / GRID_ROWS.to_f * row)).round(1)

    safe_join([grid_line(geometry, row_y), grid_label(geometry, row, row_y)])
  end

  def grid_line(geometry, row_y)
    tag.line(
      x1: geometry.left, y1: row_y, x2: geometry.right, y2: row_y,
      stroke: "rgba(255,255,255,.06)", "stroke-width": 1,
    )
  end

  def grid_label(geometry, row, row_y)
    value = geometry.max - ((geometry.max - geometry.min) / GRID_ROWS.to_f * row)

    tag.text(
      value.round.to_s,
      x: geometry.left - 8, y: row_y + 3.5, "text-anchor": "end", class: "chart-axis",
    )
  end

  def chart_date_labels(geometry)
    last = geometry.points.size - 1
    [0, (last / 2.0).round, last].uniq.map do |index|
      anchor = { 0 => "start", last => "end" }.fetch(index, "middle")
      tag.text(
        geometry.points[index].date.strftime("%b %-d"),
        x: geometry.x_at(index).round(1), y: geometry.height - 8,
        "text-anchor": anchor, class: "chart-axis",
      )
    end
  end

  def chart_history_dots(geometry)
    dots = geometry.coords[0...-1].map do |x, y|
      tag.circle(
        cx: x.round(1), cy: y.round(1), r: 2.6,
        class: "chart-dot", stroke: "currentColor", "stroke-width": 1.6,
      )
    end
    safe_join(dots)
  end

  def chart_current_dot(geometry, variant)
    x, y = geometry.coords.last.map { |value| value.round(1) }
    radius = CURRENT_DOT_RADIUS.fetch(variant)

    dot = tag.circle(cx: x, cy: y, r: radius, class: "chart-cur", "stroke-width": 1.5)
    return dot unless variant == :hero

    halo = tag.circle(cx: x, cy: y, r: radius + 3, class: "chart-halo", "fill-opacity": 0.16)
    safe_join([halo, dot])
  end

  class ChartGeometry
    attr_reader :points, :dims

    def initialize(points, dims, axis: false)
      @points = points
      @dims = dims
      @axis = axis
    end

    def width = dims[:width]
    def height = dims[:height]
    def left = dims[:pad_x] + (@axis ? 34 : 0)
    def right = width - dims[:pad_x]
    def top = dims[:pad_top]
    def bottom = height - dims[:pad_bottom]
    def inner_width = right - left
    def inner_height = bottom - top

    delegate :min, :max, to: :values

    def values
      @values ||= points.map { |point| point.weight.to_f }
    end

    def range
      spread = max - min
      spread.zero? ? 1.0 : spread
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
  end
end
