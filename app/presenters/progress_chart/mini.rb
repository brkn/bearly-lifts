# frozen_string_literal: true

class ProgressChart
  class Mini < ProgressChart
    DIMS = { width: 200, height: 62, pad_x: 4, pad_top: 8, pad_bottom: 8 }.freeze

    def css_class = "chart-mini"
    def dot_radius = 3.2
    def stroke_width = 2.4
  end
end
