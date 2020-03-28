defmodule SmogDetector.Parser do
  alias SmogDetector.Measurements

  @spec parse(binary(), binary()) :: {:ok, binary(), %Measurements{} | nil}
  def parse(accumulator, input) do
    acc = accumulator <> input
    {:ok, acc, nil}
  end
end
