defmodule Estatsd.Cache do
  @moduledoc """
  Creates an in-memory cache for dealing with metrics.
  
  The cache itself is a HashDict of Estatsd.Metric structs keyed by the
  key value of the struct. This ensures that the cache keeps track of any new metrics
  as well as updating ones that have already been sent to the daemon.
  """
  use GenServer
  
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def put(server, metric) do
    GenServer.call(server, {:put, metric})
  end

  def get(server, key) do
    GenServer.call(server, {:get, key})
  end

  def init(:ok) do
    {:ok, HashDict.new}
  end

  def handle_call({:put, metric}, _from, metrics) do
    if HashDict.has_key?(metrics, metric.key) do
      updated_metric = Estatsd.Metric.update(HashDict.get(metrics, metric.key),
        hd(metric.all_values)
      )
      {:reply, metrics, HashDict.put(metrics, metric.key, updated_metric)}
    else
      {:reply, metrics, HashDict.put(metrics, metric.key, metric)}
    end
  end

  def handle_call({:get, key}, _from, metrics) do
    {:reply, HashDict.fetch(metrics, key), metrics}
  end
end
