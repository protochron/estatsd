defmodule Estatsd.Backend.Graphite do
  use Timex

  @behaviour Estatsd.Backend

  # This might be too much like fake OOP.
  defstruct global_prefix: "",
    global_suffix: "",
    flush_interval: 0.0,
    counter_prefix: "counter",
    gauge_prefix: "gauge",
    set_prefix: "set",
    timer_prefix: "timer",
    stats_prefix: "estatsd",

    # Namespaces
    stats_namespace: [],
    counter_namespace: [],
    gauge_namespace: [],
    set_namespace: [],
    timer_namespace: [],

    # Timing data
    flush_interval: 0.0,
    last_flush: 0.0,
    last_exception: 0.0,
    flush_time: 0.0,
    flush_length: 0.0

  
  @spec new(Map) :: Map
  def new(config) do
    start_time = Date.convert(Date.now, :secs)

    global_prefix = config[:graphite][:global_prefix] || "stats"
    stats_prefix = config[:graphite][:stats_prefix] || "estatsd"
    counter_prefix = config[:graphite][:counter_prefix] || "counter"
    gauge_prefix = config[:graphite][:gauge_prefix] || "gauge"
    set_prefix = config[:graphite][:set_prefix] || "set"
    timer_prefix = config[:graphite][:timer_prefix] || "timer"
    global_suffix = config[:graphite][:global_suffix] || ""

    stats_namespace = Enum.join([global_prefix, stats_prefix], ".")
    counter_namespace = [stats_namespace, counter_prefix]
    gauge_namespace = [stats_namespace, gauge_prefix]
    set_namespace = [stats_namespace, set_prefix]
    timer_namespace = [stats_namespace, timer_prefix]

    %Estatsd.Backend.Graphite {
      flush_interval: config[:flush_interval],
      last_flush: start_time,
      last_exception: start_time,

      global_prefix: global_prefix,
      global_suffix: global_suffix,
      stats_prefix: stats_prefix,
      counter_prefix: counter_prefix,
      gauge_prefix: gauge_prefix,
      set_prefix: set_prefix,
      timer_prefix: timer_prefix,

      stats_namespace: stats_namespace,
      counter_namespace: counter_namespace,
      gauge_namespace: gauge_namespace,
      set_namespace: set_namespace,
      timer_namespace: timer_namespace,
    }
  end

  @spec send_stats(Map, Map, Map) :: Map
  def send_stats(stats, config, backend) do
    #connection = Estatsd.Backend.Graphite.Connection(config[:mode])
  end

  defp get_namespace(backend, namespace) do
    global_namespace = backend.stats_namespace
    global_suffix = backend.global_suffix
    case namespace do
      :counter -> join_string([global_namespace, "rate", global_suffix])
      :set -> join_string([global_namespace, "count", global_suffix])
      :gauge -> join_string([global_namespace, global_suffix])
      # Handle this
      _ -> "error"
    end
  end

  defp get_namespace(backend, namespace, key) do
    global_namespace = backend.stats_namespace
    global_suffix = backend.global_suffix
    case namespace do
      :timer -> join_string([global_namespace, key, global_suffix])
    end
  end

  @spec join_string(List) :: String
  defp join_string(list) do
    Enum.join(list, ".")
  end


  # Backend server stuff
  def get_connection(mode) do
    case mode do
      :tcp -> Estatsd.Backend.Graphite.Tcp
      :udp -> Estatsd.Backend.Graphite.Udp
    end
  end

  @spec connection(Atom) :: Map
  def connection(mode) do
    get_connection(mode).connection
  end

end
