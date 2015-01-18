defmodule Estatsd.Metric do
  @moduledoc """
  Defines a metric

  A metric is a struct keyed by a Graphite-compatable string. It contains a
  list of values and metadata about those values including how often the metric
  has been updated.
  """
  alias Statistics, as: S

  @metric_types %{"c" => :counter, "g" => :gauge, "t" => :timer, "s" => :set}
  @namespace_seperator ":"
  @type_seperator "|"


  @doc """
  Struct definition
  """
  defstruct key: "",
    type: :counter,
    total_hits: 0,
    last_value: 0.0,
    values_per_second: 0.0,
    min_value: 0.0,
    max_value: 0.0,
    median_value: 0.0,
    quantiles: [], 
    all_values: [],
    flush_time: 0,
    last_flushed: 0

    @doc """
    A simple way to create a metric for the first time. This is meant to be called when a
    metric is not defined in the cache
    """
    def create_metric(key, value, type \\ :counter) do
      %Estatsd.Metric {
        key: key,
        last_value: value,
        all_values: [value],
        type: type,
        total_hits: 1,
        min_value: value,
        max_value: value,
        median_value: value
      }
    end

    @doc """
    Update a metric with a new value.
    This takes care of updating the list of values with the correct metadata
    """
    @spec update(Map, Integer, Integer, List) :: Map
    def update(struct, value, flush_interval, quantiles) do
      # TODO: make this more efficient?
      vals = struct.all_values ++ [value]
      metric = %Estatsd.Metric {
        key: struct.key,
        type: struct.type,
        total_hits: struct.total_hits + 1,
        #last_value: update_last_value(struct, value),
        values_per_second: struct.values_per_second,
        min_value: Enum.min(vals),
        max_value: Enum.max(vals),
        median_value: S.median(vals),
        # TODO: Use this struct
        all_values: vals,
        flush_time: struct.flush_time,
        last_flushed: struct.last_flushed
      }

      process_metric(metric, value, flush_interval, quantiles)
    end

    def process_metric(metric, value, flush_interval, quantiles) do
      case metric.type do
        :counter ->
          %{metric |
            last_value: metric.last_value + value,
            values_per_second: metric.last_value / flush_interval
          }
        :set ->
          %{metric | last_value: update_last_value(metric, value)}
        :timer ->
          process_timer(metric, value, quantiles)
        _ ->
          metric
      end
    end

    def process_timer(metric, value, quantiles) do
    end

    @doc """
    Take care of any special cases that exist when updating the
    last_value field of an Estatsd.Metric
    """
    def update_last_value(struct, value) do
      case struct.type do
        :counter -> struct.last_value + value
        :set -> Enum.uniq(struct.all_metrics) |> Enum.count
        _ -> value
      end
    end

    @doc """
    Parse out a StatsD metric string into a tuple.

    A correctly formatted string resembles the following:
        
        '<metric_name>:<value>|<type>'
    Raise an exception if any of the fields are incorrect.
    """
    def parse_metric!(metric) do
      [name, value] = String.split(metric, @namespace_seperator)
      [value, type] = String.split(value, @type_seperator)
      type = Map.fetch!(@metric_types, type)
      {float_value, _} = Float.parse(value)
      {name, float_value, type}
    end

    defp update_quantiles(metric, percentiles) do
    end

    defp update_quantile(quantile, percentile) do
      p = percentile / 100
      quantile = %Estatsd.MetricQuantile{}
    end
end
