defmodule Estatsd.Server.Tcp do
  @moduledoc """
  An implementation of a TCP server for receiving metrics.

  This allows Estatsd to accept metrics over TCP.
  """

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port,
      [:binary, packet: :line, active: false])
    IO.puts "Accepting connections on port #{port} TCP"
    loop_acceptor(socket)
  end

  def loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    serve(client)
    loop_acceptor(socket)
  end

  def serve(client) do
    read_line(client)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    Task.Supervisor.start_child(Estatsd.TaskSupervisor, fn ->
      Estatsd.load_metric(String.strip(data))
    end)
  end
end
