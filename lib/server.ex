defmodule Kappa.Server do


  def listen(port) do
    tcp_options = [:list, {:packet, 0}, {:active, false}, {:reuseaddr, true}]

    {:ok, l_socket} = :gen_tcp.listen(port, tcp_options)

    do_listen(l_socket)
  end

  defp do_listen(l_socket) do
    {:ok, socket} = :gen_tcp.accept(l_socket)

    spawn(fn() -> do_server(socket) end)

    do_listen(l_socket)
  end

  defp do_server(socket) do
    case :gen_tcp.recv(socket, 0) do

      { :ok, data } -> 
        IO.puts "PARSING:"
        IO.puts data

        res = try do
          process(nil)#Kappa.Parser.parse(data))
        rescue
          x in [RuntimeError] ->
            IO.puts x.message
            {500, [], "Something went wrong"}
        end

        encoded = Kappa.Encoder.encode(res)
        IO.puts "RESPONDING:"
        IO.puts encoded

        :gen_tcp.send(socket, encoded)

        do_server(socket)

      { :error, :closed } -> :ok
    end
  end

  defp process(request) do
    {200, [], ""}
  end

end
