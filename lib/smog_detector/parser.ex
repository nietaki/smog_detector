defmodule SmogDetector.Parser do
  alias SmogDetector.Measurements

  @spec parse(binary(), binary()) :: {:ok, binary(), %Measurements{} | nil}
  def parse(accumulator, input) do
    acc = accumulator <> input

    do_parse(acc)
  end

  defp do_parse(
         <<66, 77, _fluff::binary-size(8), meat::binary-size(6),
           _rest_of_the_frame::binary-size(8), tail::binary>>
       ) do
    <<pm10_bytes::binary-size(2), pm25_bytes::binary-size(2), pm100_bytes::binary-size(2)>> = meat

    m = %Measurements{
      pm10: :binary.decode_unsigned(pm10_bytes),
      pm25: :binary.decode_unsigned(pm25_bytes),
      pm100: :binary.decode_unsigned(pm100_bytes)
    }

    {:ok, tail, m}
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
