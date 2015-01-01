defmodule Estatsd.Server.Tcp do

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port,
      [:binary, packet: :line, active: false])
    IO.puts "Accepting connections on port #{port} TCP"
    loop_acceptor(socket)
  end

  def loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    serve(client)
    #TaskSupervisor.start_child(Estatsd.TaskSupervistor, fn -> serve(client) end)
    loop_acceptor(socket)
  end

  def serve(client) do
    read_line(client)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    #Estatsd.Server.load_metric(data)
    TaskSupervisor.start_child(Estatsd.TaskSupervisor, fn ->
      Estatsd.Server.load_metric(data)
    end)
  end
end
