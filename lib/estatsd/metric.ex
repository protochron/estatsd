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
    percentiles: [], 
    all_values: [],
    flush_time: 0,
    last_flushed: 0

    @doc """
    A simple way to create a metric for the first time. This is meant to be called when a
    metric is not defined in the cache
    """
    @spec create_metric(String, Integer, Atom) :: Map
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
    Create a metric from a previously parsed metric string
    """
    @spec create_metric(Tuple) :: Map
    def create_metric(parsed_string) do
      {key, value, type} = parsed_string
      create_metric(key, value, type)
    end

    @doc """
    Update a metric with a new value.
    This takes care of updating the list of values with the correct metadata
    """
    @spec update(Map, Integer, Integer, List) :: Map
    def update(struct, value, flush_interval, percentiles) do
      # TODO: make this more efficient?
      vals = struct.all_values ++ [value]
      metric = %Estatsd.Metric {
        key: struct.key,
        type: struct.type,
        total_hits: struct.total_hits + 1,
        last_value: value,
        values_per_second: struct.values_per_second,
        min_value: Enum.min(vals),
        max_value: Enum.max(vals),
        median_value: S.median(vals),
        # TODO: Use this struct
        all_values: vals,
        flush_time: struct.flush_time,
        last_flushed: struct.last_flushed,
        percentiles: []
      }

      process_metric(metric, value, flush_interval, percentiles)
    end

    @doc """
    Update specific portions of the struct depending on the type of metric
    """
    @spec process_metric(Map, Integer, Integer, List) :: Map
    def process_metric(metric, value, flush_interval, percentiles) do
      case metric.type do
        :counter ->
          %{metric |
            last_value: metric.last_value + (metric.last_value * metric.total_hits),
            values_per_second: metric.last_value / flush_interval
          }
        :set ->
          %{metric | last_value: Enum.uniq(metric.all_values) |> Enum.count}
        :timer ->
          process_timer(metric, percentiles, flush_interval)
        _ ->
          %{metric | last_value: value}
      end
    end

    @doc """
    Update the percentiles for the timer
    """
    @spec process_timer(Map, List, Integer) :: Map
    def process_timer(metric, percentiles, flush_interval) do
      percentiles = Enum.reduce(percentiles, [], fn(p, acc) -> 
        acc ++ [Estatsd.MetricPercentile.create(metric.all_values, p)] end)
      %{metric | 
        percentiles: percentiles,
        values_per_second: metric.last_value / flush_interval
      }
    end

    @doc """
    Parse out a StatsD metric string into a tuple.

    A correctly formatted string resembles the following:
        
        '<metric_name>:<value>|<type>'
    Raise an exception if any of the fields are incorrect.
    """
    @spec parse_metric!(Map) :: String
    def parse_metric!(metric) do
      [name, value] = String.split(metric, @namespace_seperator)
      [value, type] = String.split(value, @type_seperator)
      type = Map.fetch!(@metric_types, type)
      {float_value, _} = Float.parse(value)
      {name, float_value, type}
    end
end
