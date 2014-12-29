defmodule Estatsd do
  use Application

  @name __MODULE__

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
    ]

    opts = [strategy: :one_for_one, name: Sequence.Supervisor]
    Supervisor.start_link(children, opts)
  end

  ##
  # External API
  def start_link do
    Agent.start_link(fn -> HashDict.new end, name: @name)
  end

end
