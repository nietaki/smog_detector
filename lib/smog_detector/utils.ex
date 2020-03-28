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
end
