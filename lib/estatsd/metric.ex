defmodule Estatsd.Metric do
  import Estatsd.Utils

  @metric_types {:counter, :gauge, :timer}

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

    def create_metric(key, value, type \\ :counter) do
      %Estatsd.Metric{key: key,
        last_value: value,
        all_values: [value],
        type: type
      }
    end

    def update(struct, value) do
      # TODO: make this more efficient?
      vals = struct.all_values ++ [value]
      %Estatsd.Metric{key: struct.key,
        type: struct.type,
        total_hits: struct.total_hits,
        last_value: struct.last_value,
        values_per_second: struct.values_per_second,
        min_value: min(vals),
        max_value: max(vals),
        median_value: median(vals),
        quantiles: %Estatsd.MetricQuantile{},
        all_values: vals,
        flush_time: struct.flush_time,
        last_flushed: struct.last_flushed
      }
    end

    def metric_type!(type) do
      case type do
        "g" -> {:ok, :gauge}
        "c" -> {:ok, :counter}
        "t" -> {:ok, :timer}
        _ -> {:error, "bad metric type"}
      end
    end

    def parse_metric(metric) do
      [name, value] = String.split(metric, ":")
      [value, type] = String.split(value, "|")
      {:ok, type} = metric_type!(type)
      {name, value, type}
    end
end
