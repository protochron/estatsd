defmodule Estatsd.Backend.Graphite.Tcp do
  @moduledoc """
  Define some functions to send data to a Graphite server over TCP.
  """

  def connect(host, port, options \\ nil) do
    :gen_tcp.connect(host, port, options)
  end

  def send(socket, data) do
    :gen_tcp.send(socket, data)
  end
end
