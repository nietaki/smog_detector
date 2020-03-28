defmodule SmogDetector.Parser do
  alias SmogDetector.Measurements

  @spec parse(binary(), binary()) :: {:ok, binary(), %Measurements{} | nil}
  def parse(accumulator, input) do
    acc = accumulator <> input

    do_parse(acc)
  end

  defp do_parse(<<66, 77, _rest::binary>> = acc) do
    {:ok, acc, nil}
  end

  defp do_parse(<<_, _, foobar::binary>>) do
    do_parse(foobar)
  end

  defp do_parse("") do
    {:ok, "", nil}
  end

  # accumulator = ""
  # while input <- uart do
  #   {:ok, accumulator, measurements} = Parser.parse(accumulator, input)
  #   submit_measurements(measurements)
  # end
end
