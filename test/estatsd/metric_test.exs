defmodule Estatsd.MetricTest do
  use ExUnit.Case, async: true
  alias Estatsd.Metric

  def simple_counter do
    %Metric{key: "test.metric",
      last_value: 0.1,
      all_values: [0.1],
      type: :counter,
      total_hits: 1
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
    assert Metric.create_metric("test.metric", 0.1, :counter) == simple_counter
  end

  test "updates a metric" do
    updated_metric = Metric.update(simple_counter, 0.2)
    assert updated_metric != simple_counter
    # You can't always assume that floating point math gives you the same value, so compare against the string representation instead
    last_value = Float.to_string(updated_metric.last_value, [decimals: 2, compact: true])
    assert last_value == "0.3"
    median_value = Float.to_string(updated_metric.median_value, [decimals: 2])
    assert median_value == "0.15"

    assert updated_metric.all_values == [0.1, 0.2]
    assert updated_metric.min_value == 0.1
  end
end
