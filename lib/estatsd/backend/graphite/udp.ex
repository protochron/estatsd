defmodule Estatsd.Backend.Graphite.Udp do
  @moduledoc """
  Send stats to a Graphite server over UDP.
  """

  def connect(port \\ 0) do
    :gen_udp.open(port)
  end

  def send(socket, address, port, data) do
    :gen_udp.send(socket, address, port, data)
  end

end
