defmodule Estatsd.MetricTest do
  use ExUnit.Case, async: true
  alias Estatsd.Metric

  def simple_counter do
    %Metric{key: "test.metric",
      last_value: 0.1,
      all_values: [0.1],
      type: :counter,
      total_hits: 1,
      max_value: 0.1,
      min_value: 0.1,
      median_value: 0.1
    }
  end

  test "parses a metric" do
    good_metric = "test.metric:0.1|c"
    assert Metric.parse_metric!(good_metric) == {"test.metric", 0.1, :counter}
  end

  test "fails to parse a bad metric" do
    bad_type = "test.metric:0.1|F"
    bad_value = "test.metric:f|c"
    bad_seperator = "test.metric\0.1|c"

    assert_raise MatchError, fn ->
      Metric.parse_metric!(bad_seperator)
    end

    assert_raise KeyError, fn ->
      Metric.parse_metric!(bad_type)
    end

    assert_raise MatchError, fn -> 
      Metric.parse_metric!(bad_value)
    end
  end

  test "creates a metric" do
    metric = Metric.create_metric("test.metric", 0.1, :counter) 
    assert metric == simple_counter
    assert metric.last_value == 0.1
  end

  test "updates a counter" do
    updated_metric = Metric.update(simple_counter, 0.2, 1000, [90])
    assert updated_metric != simple_counter
    # You can't always assume that floating point math gives you the same value, so compare against the string representation instead
    last_value = Float.to_string(updated_metric.last_value, [decimals: 2, compact: true])
    assert last_value == "0.6"
    median_value = Float.to_string(updated_metric.median_value, [decimals: 2])
    assert median_value == "0.15"

    assert updated_metric.all_values == [0.1, 0.2]
    assert updated_metric.min_value == 0.1
    assert updated_metric.max_value == 0.2
  end

  test "updates a gauge" do
    gauge = Metric.create_metric("test.metric", 0.1, :gauge)
    updated_gauge = Metric.update(gauge, 0.2, 1000, [90])
    assert updated_gauge.all_values == [0.1, 0.2]
    assert updated_gauge.last_value == 0.2
  end

  test "updates a set" do 
    set = Metric.create_metric("test.metric", 0.1, :set)
    updated_set = Metric.update(set, 0.2, 1000, [90])
    assert updated_set.all_values == [0.1, 0.2]
    assert updated_set.last_value == 2
  end

  test "updates a timer" do
    timer = Metric.create_metric("test.metric", 0.1, :timer)
    updated_timer = Metric.update(timer, 0.2, 1000, [90, 95])
    assert Enum.count(updated_timer.percentiles) == 2
  end
end
