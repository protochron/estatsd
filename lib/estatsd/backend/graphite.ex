defmodule Estatsd.Backend.Graphite do
  @behaviour Estatsd.Backend

  # This might be too much like fake OOP.
  defstruct global_prefix: "",
    global_suffix: "",
    flush_interval: 0.0,
    counter_prefix: "",
    gauge_prefix: "",
    set_prefix: "",
    timer_prefix: "",
    stats_prefix: "",

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
    %Estatsd.Backend.Graphite{ flush_interval: config[:flush_interval],
      last_flush: start_time,
      last_exception: start_time
    }
  end

  #@spec new(Map, Integer) :: Map
  #def new(config, start_time) do
  #  %Estatsd.Backend.Graphite{ flush_interval: config[:flush_interval],
  #    last_flush: start_time,
  #    last_exception: start_time
  #  }
  #end

  @spec send_stats(Map, Map, Map) :: Map
  def send_stats(stats, config, backend) do
    #connection = Estatsd.Backend.Graphite.Connection(config[:mode])
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
