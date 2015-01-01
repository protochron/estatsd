defmodule Estatsd.Server.Udp do

  def accept(port) do
    {:ok, socket} = :gen_udp.open(port,
      [:binary, active: false])
    IO.puts "Accepting connections on #{port} UDP"
    loop_acceptor(socket)
  end

  def loop_acceptor(socket) do
    {:ok, {_, _, data}} = :gen_udp.recv(socket, 0)

    Task.Supervisor.start_child(Estatsd.TaskSupervisor, fn ->
      Estatsd.load_metric(String.strip(data))
    end)
    loop_acceptor(socket)
  end
end
