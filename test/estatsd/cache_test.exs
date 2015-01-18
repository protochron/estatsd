defmodule Estatsd.CacheTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, cache} = Estatsd.Cache.start_link
    sample_metric = Estatsd.Metric.create_metric("test.metric", 0.1)
    {:ok, cache: cache, metric: sample_metric}
  end

  test "adds a new metric", %{cache: cache, metric: metric} do
    assert Estatsd.Cache.get(cache, "test.metric") == :error
    Estatsd.Cache.put(cache, metric)
    assert {:ok, metric} == Estatsd.Cache.get(cache, "test.metric")
  end

  test "updates a metric", %{cache: cache, metric: metric} do
    for _ <- 0..1, do: Estatsd.Cache.put(cache, metric)
    {:ok, up_metric} = Estatsd.Cache.get(cache, "test.metric")
    assert up_metric == Estatsd.Metric.update(metric, 0.1, 60, [90])
  end

end
