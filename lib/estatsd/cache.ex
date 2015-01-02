defmodule Estatsd.Cache do
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
