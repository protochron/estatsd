defmodule Estatsd.Backend.Graphite do
  use Timex

  @behaviour Estatsd.Backend

  # This might be too much like fake OOP.
  defstruct global_prefix: "",
    global_suffix: "",
    flush_interval: 0.0,
    flush_counts: false,
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
    start_time = timestamp

    global_prefix = config[:graphite][:global_prefix] || "stats"
    stats_prefix = config[:graphite][:stats_prefix] || "estatsd"
    counter_prefix = config[:graphite][:counter_prefix] || "counter"
    gauge_prefix = config[:graphite][:gauge_prefix] || "gauge"
    set_prefix = config[:graphite][:set_prefix] || "set"
    timer_prefix = config[:graphite][:timer_prefix] || "timer"
    global_suffix = config[:graphite][:global_suffix] || ""

    stats_namespace = join_string([global_prefix, stats_prefix])
    counter_namespace = join_string([stats_namespace, counter_prefix])
    gauge_namespace = join_string([stats_namespace, gauge_prefix])
    set_namespace = join_string([stats_namespace, set_prefix])
    timer_namespace = join_string([stats_namespace, timer_prefix])

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

  @spec get_namespace(Map, String, String) :: String
  def get_namespace(backend, namespace, key) do
    global_suffix = backend.global_suffix
    case namespace do
      :counter -> join_string([backend.counter_namespace, key, "rate", global_suffix])
      :set -> join_string([backend.set_namespace, key, "count", global_suffix])
      :gauge -> join_string([backend.gauge_namespace, key, global_suffix])
      :timer -> join_string([backend.timer_namespace, key, global_suffix])
      # Handle this
      _ -> "error"
    end
  end

  @spec stat_string(String, Integer, Integer) :: String
  def stat_string(namespace, stat_value, timestamp) do
    "#{namespace} #{stat_value} #{timestamp}"
  end

  defp timestamp do
    Date.convert(Date.now, :secs)
  end

  #@spec join_string(List) :: String
  defp join_string(list) do
    Enum.filter(list, fn(x) -> x != "" end) |> Enum.join(".")
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
