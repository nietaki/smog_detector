defmodule SmogDetector.ParserTest do
  use ExUnit.Case

  # {:circuits_uart, "ttyAMA0", <<66, 77, 0, 28, 0, 53, 0, 81>>}
  # {:circuits_uart, "ttyAMA0", <<0, 101, 1, 34, 0, 53, 0, 73>>}
  # {:circuits_uart, "ttyAMA0", <<36, 60, 10, 189, 1, 212, 0, 68>>}
  # {:circuits_uart, "ttyAMA0", <<0, 33, 0, 12, 151, 0, 5, 58>>}
  # {:circuits_uart, "ttyAMA0", <<66, 77, 0, 28, 0, 53, 0, 81>>}
  # {:circuits_uart, "ttyAMA0", <<0, 104, 0, 34, 0, 53, 0, 74>>}
  # {:circuits_uart, "ttyAMA0", <<36, 60, 10, 182, 1, 211, 0, 77>>}
  # {:circuits_uart, "ttyAMA0", <<0, 38, 0, 13, 151, 0, 5, 69>>}
  # {:circuits_uart, "ttyAMA0", <<66, 77, 0, 28, 0, 53, 0, 82>>}
  # {:circuits_uart, "ttyAMA0", <<0, 106, 0, 35, 0, 53, 0, 76>>}
  # {:circuits_uart, "ttyAMA0", <<35, 136, 10, 113, 1, 216, 0, 80>>}
  # {:circuits_uart, "ttyAMA0", <<0, 38, 0, 15, 151, 0, 5, 91>>}
  # {:circuits_uart, "ttyAMA0", <<66, 77, 0, 28, 0, 51, 0, 79>>}
  # {:circuits_uart, "ttyAMA0", <<0, 96, 0, 34, 0, 52, 0, 72>>}
  # {:circuits_uart, "ttyAMA0", <<34, 92, 10, 35, 1, 191, 0, 65>>}
  # {:circuits_uart, "ttyAMA0", <<0, 27, 0, 10, 151, 0, 4, 147>>}
  # {:circuits_uart, "ttyAMA0", <<66, 77, 0, 28, 0, 52, 0, 77>>}
  # {:circuits_uart, "ttyAMA0", <<0, 90, 0, 35, 0, 52, 0, 69>>}
  # {:circuits_uart, "ttyAMA0", <<34, 86, 10, 13, 1, 171, 0, 50>>}
  # {:circuits_uart, "ttyAMA0", <<0, 20, 0, 7, 151, 0, 4, 65>>}
  # {:circuits_uart, "ttyAMA0", <<66, 77, 0, 28, 0, 51, 0, 76>>}
  # {:circuits_uart, "ttyAMA0", <<0, 89, 0, 34, 0, 52, 0, 68>>}
  # {:circuits_uart, "ttyAMA0", <<34, 77, 10, 6, 1, 169, 0, 54>>}
  # {:circuits_uart, "ttyAMA0", <<0, 20, 0, 7, 151, 0, 4, 46>>}
  # {:circuits_uart, "ttyAMA0", <<66, 77, 0, 28, 0, 51, 0, 76>>}
  # {:circuits_uart, "ttyAMA0", <<0, 88, 0, 34, 0, 52, 0, 68>>}
  # {:circuits_uart, "ttyAMA0", <<34, 50, 9, 252, 1, 162, 0, 52>>}
  # {:circuits_uart, "ttyAMA0", <<0, 19, 0, 6, 151, 0, 4, 252>>}
  # {:circuits_uart, "ttyAMA0", <<66, 77, 0, 28, 0, 50, 0, 75>>}
  # {:circuits_uart, "ttyAMA0", <<0, 87, 0, 34, 0, 51, 0, 67>>}
  # {:circuits_uart, "ttyAMA0", <<33, 159, 9, 201, 1, 149, 0, 52>>}
  # {:circuits_uart, "ttyAMA0", <<0, 19, 0, 6, 151, 0, 5, 35>>}
  # {:circuits_uart, "ttyAMA0", <<66, 77, 0, 28, 0, 50, 0, 75>>}
  # {:circuits_uart, "ttyAMA0", <<0, 87, 0, 34, 0, 51, 0, 67>>}
  # {:circuits_uart, "ttyAMA0", <<33, 159, 9, 201, 1, 149, 0, 52>>}
  # {:circuits_uart, "ttyAMA0", <<0, 19, 0, 6, 151, 0, 5, 35>>}
  # {:circuits_uart, "ttyAMA0", <<66, 77, 0, 28, 0, 49, 0, 74>>}
  # {:circuits_uart, "ttyAMA0", <<0, 86, 0, 34, 0, 51, 0, 67>>}
  # {:circuits_uart, "ttyAMA0", <<32, 181, 9, 152, 1, 147, 0, 54>>}
  # {:circuits_uart, "ttyAMA0", <<0, 19, 0, 5, 151, 0, 5, 3>>}

  @first_eight_bytes <<66, 77, 0, 28, 0, 53, 0, 81>>
  @second_eight_bytes <<0, 101, 1, 34, 0, 53, 0, 73>>
  @third_eight_bytes <<36, 60, 10, 189, 1, 212, 0, 68>>
  @fourth_eight_bytes <<0, 33, 0, 12, 151, 0, 5, 58>>

  alias SmogDetector.Parser
  alias SmogDetector.Measurements

  describe "parse" do
    test "uses the accumulator" do
      assert {:ok, @first_eight_bytes, nil} = Parser.parse("", @first_eight_bytes)
    end

    test "when it doesn't get the beginning of the frame with an empty buffer" do
      assert {:ok, "", nil} = Parser.parse("", @second_eight_bytes)
    end

    test "when it has data to append to the frame" do
      assert {:ok, @first_eight_bytes <> @second_eight_bytes, nil} =
               Parser.parse(@first_eight_bytes, @second_eight_bytes)
    end

    test "returns correct measurements when it has the whole packet" do
      acc = @first_eight_bytes <> @second_eight_bytes <> @third_eight_bytes
      input = @fourth_eight_bytes
      assert {:ok, _, measurements} = Parser.parse(acc, input)
      assert measurements != nil
      assert %Measurements{pm10: 290, pm25: 53, pm100: 73} = measurements
    end
  end
end
