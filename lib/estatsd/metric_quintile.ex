defmodule Estatsd.MetricQuantile do
  defstruct quantile: 0,
    boundary: 0.0,
    all_values: [],
    mean: 0.0,
    median: 0.0,
    max: 0.0,
    sum: 0.0
end
