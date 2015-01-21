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
  @sample_seperator "@"

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
    last_flushed: 0,
    sample_rate: 0.0

    @doc """
    A simple way to create a metric for the first time. This is meant to be called when a
    metric is not defined in the cache
    """
    @spec create_metric(String, Integer, Atom) :: Map
    def create_metric(key, value, type \\ :counter, sample_rate \\ 1.0) do
      cond do
        sample_rate < 1.0 ->
          total_hits = 1.0 / sample_rate
        true ->
          total_hits = 1
      end

      %Estatsd.Metric {
        key: key,
        last_value: value,
        all_values: [value],
        type: type,
        total_hits: total_hits,
        min_value: value,
        max_value: value,
        median_value: value,
        sample_rate: sample_rate
      }
    end

    @doc """
    Create a metric from a previously parsed metric string
    """
    @spec create_metric(Tuple) :: Map
    def create_metric(parsed_string) do
      case parsed_string do
        {key, value, type} -> create_metric(key, value, type)
        {key, value, type, sample_rate} -> create_metric(key, value, type, sample_rate)
      end
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
        
        '<metric_name>:<value>|<type>|<sample_rate>'

    The sample_rate is only used for counters.
    Raises an exception if any of the fields are incorrect.
    """
    @spec parse_metric!(String) :: Map
    def parse_metric!(metric) do
      sample_rate = 1.0
      value = nil
      type = nil
      [name, value] = String.split(metric, @namespace_seperator)
      case String.split(value, @type_seperator) do
        [v, t, rate] ->
          {sample_rate, _} = String.replace(rate, ~r/@/, "") |> Float.parse
          value = v
          type = t
        [v, t] ->
          value = v
          type = t
      end
      type = Map.fetch!(@metric_types, type)
      {float_value, _} = Float.parse(value)
      case type do
        :counter ->
          {name, float_value, type, sample_rate}
        _ ->
          {name, float_value, type}
      end
    end
end
