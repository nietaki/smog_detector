defmodule SmogDetector.Sensor do
  use GenServer
  @port "ttyAMA0"

  alias SmogDetector.Parser

  defstruct accumulator: "",
            uart_pid: nil,
            latest_measurements: nil

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def get_latest_measurements() do
    GenServer.call(__MODULE__, :get_latest_measurements)
  end

  # GenServer callbacks

  @impl GenServer
  def init(_opts) do
    {:ok, pid} = Circuits.UART.start_link()
    :ok = Circuits.UART.open(pid, @port, speed: 9600, active: true)

    state = %__MODULE__{
      accumulator: "",
      uart_pid: pid,
      latest_measurements: nil
    }

    {:ok, state}
  end

  @impl GenServer
  def handle_call(:get_latest_measurements, _from, %__MODULE__{latest_measurements: lm} = state) do
    {:reply, lm, state}
  end

  @impl GenServer
  def handle_info(
        {:circuits_uart, _port, data},
        %__MODULE__{accumulator: acc, latest_measurements: measurements} = old_state
      ) do
    {:ok, acc, maybe_measurements} = Parser.parse(acc, data)

    latest_measurements = maybe_measurements || measurements

    new_state = %__MODULE__{
      old_state
      | accumulator: acc,
        latest_measurements: latest_measurements
    }

    {:noreply, new_state}
  end
end
