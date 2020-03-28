defmodule SmogDetector.Utils do
  def flush_circuit_messages do
    do_flush_circuit_messages([])
  end

  defp do_flush_circuit_messages(acc) do
    receive do
      {:circuits_uart, _port, data} ->
        do_flush_circuit_messages([data | acc])
    after
      0 ->
        Enum.reverse(acc)
    end
  end

  # def loop(state) do
  #   receive do
  #     {:circuits_uart, _port, data} ->
  #       # shange state here
  #       loop(state)
  #     # {:call, :get_latest_measurements, from} ->
  #     #   send(from, state.latest_measurements)
  #     #   # shange state here
  #     #   loop(state)
  #   after
  #     100 ->
  #       loop(state)
  #   end
  # end
end
