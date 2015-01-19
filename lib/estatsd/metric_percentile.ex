defmodule Estatsd.MetricPercentile do

  alias Statistics, as: S

  defstruct percentile: 0,
    boundary: 0.0,
    all_values: [],
    mean: 0.0,
    median: 0.0,
    max: 0.0,
    sum: 0.0

  def create(values, percentile) do
    percentile = S.percentile(values, percentile)
    vals = Enum.filter(values, fn(x) -> x <= percentile end)
    %Estatsd.MetricPercentile {
      percentile: percentile,
      boundary: percentile,
      all_values: values,
      mean: S.mean(vals),
      median: S.median(vals),
      max: S.max(vals),
      sum: S.sum(vals)
    }
  end
end
