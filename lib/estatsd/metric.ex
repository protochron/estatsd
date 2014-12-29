defmodule Estatsd.Metric do
  defstruct key: "",
    type: :counter,
    total_hits: 0,
    last_value: 0.0,
    values_per_second: 0.0,
    min_value: 0.0,
    max_value: 0.0,
    median_value: 0.0,
    quantiles: Estatsd.MetricQuantile,
    all_values: [],
    flush_time: 0,
    last_flushed: 0
end
