# frozen_string_literal: true

module ProgressHelper
  def progress_chart(lift, variant:)
    chart = ProgressChart.for(variant).new(lift)

    render chart.partial_path, chart: chart
  end
end
