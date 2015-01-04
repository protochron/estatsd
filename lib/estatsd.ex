defmodule Estatsd do
  use Application

  # Configuration options
  @mode Application.get_env(:estatsd, :mode)
  @carbon_port Application.get_env(:estatsd, :carbon_port)
  @carbon_host Application.get_env(:estatsd, :carbon_host)
  @port Application.get_env(:estatsd, :port)
  @debug Application.get_env(:estatsd, :debug)
  @server_mode Application.get_env(:estatsd, :server_mode)

  @doc false
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Estatsd.Cache, [[name: Estatsd.CacheSupervisor]]),
      supervisor(Task.Supervisor, [[name: Estatsd.TaskSupervisor]]),
      worker(Task, [Estatsd, :accept, []])
    ]

    opts = [strategy: :one_for_one, name: Estatsd.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Get the correct server to use for receiving metrics.

  The server is defined as a configuration option in Mix or in the estatsd.conf
  file.
  """
  def get_server do
    case @mode do
      :tcp -> Estatsd.Server.Tcp
      :udp -> Estatsd.Server.Udp
    end
  end

  @doc """
  Accept new metrics using the correct server implementation.
  """
  def accept do
    get_server.accept(@port)
  end

  @doc """
  Parse a metric string and store it in the cache.
  """
  def load_metric(metric_string) do
    {key, value, type} = Estatsd.Metric.parse_metric!(metric_string)
    m = Estatsd.Metric.create_metric(key, value, type)
    Estatsd.Cache.put(Estatsd.CacheSupervisor, m)
  end

end
