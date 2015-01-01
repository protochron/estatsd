defmodule Estatsd.Cache do
  use GenServer
  
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, HashDict.new)
  end

  def put(server, metric) do
    GenServer.call(server, {:put, metric})
  end

  def get(server, key) do
    GenServer.call(server, {:get, key})
  end

  def handle_call({:put, metric}, _from, metrics) do
    if HashDict.has_key?(metrics, metric.key) do
      updated_metric = Estatsd.Metric.update(HashDict.get(metrics, metric.key), hd(metric.all_values))
      {:reply, HashDict.put(metrics, metric.key, updated_metric), metrics}
    else
      {:reply, HashDict.put(metrics, metric.key, metric), metrics}
    end
  end

  def handle_call({:get, key}, _from, metrics) do
    {:reply, HashDict.get(metrics, key), metrics}
  end
end
