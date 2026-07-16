# frozen_string_literal: true

class ProgressChart
  class Rail < ProgressChart
    DIMS = { width: 88, height: 30, pad_x: 3, pad_top: 5, pad_bottom: 5 }.freeze

    def css_class = "chart-rail"
    def dot_radius = 2.6
    def stroke_width = 1.8
  end
end
