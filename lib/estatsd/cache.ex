defmodule Estatsd.Cache do
  use GenServer
  
  def start_link do
    GenServer.start_link(__MODULE__, HashDict.new)
  end

  def put(server, metric) do
    GenServer.call(server, {:put, metric})
  end

  def get(server, key) do
    GenServer.call(server, {:get, key})
  end

  def handle_call({:put, metric}, _from, state) do
    {:reply, HashDict.update(state, metric.key, metric)}
  end

  def handle_call({:get, key}, _from, state) do
    {:reply, HashDict.get(state, key), state}
  end
end
