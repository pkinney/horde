defmodule Counter.Router.PID do
  def increment(name) do
    Counter.Router.lookup_and_start_if_needed(name)
    |> GenServer.cast(:increment)
  end

  def value(name) do
    Counter.Router.lookup_and_start_if_needed(name)
    |> GenServer.call(:value)
  end
end

defmodule Counter.Router.Via do
  def increment(name) do
    Counter.Router.lookup_and_start_if_needed(name)
    GenServer.cast(Counter.Worker.via_tuple(name), :increment)
  end

  def value(name) do
    Counter.Router.lookup_and_start_if_needed(name)
    GenServer.call(Counter.Worker.via_tuple(name), :value)
  end
end

defmodule Counter.Router do
  require Logger

  def lookup_and_start_if_needed(name) do
    lookup =
      Horde.Registry.lookup(
        Counter.Registry,
        name
      )

    case lookup do
      :undefined ->
        Logger.debug("[#{__MODULE__}] Process not found for \"#{name}\".")

        {:ok, pid} =
          Horde.Supervisor.start_child(
            Counter.CounterSupervisor,
            {Counter.Worker, name: name}
          )

        Logger.debug("[#{__MODULE__}] New process started for \"#{name}\" (#{inspect(pid)})")

        pid

      [{pid, _}] ->
        Logger.debug("[#{__MODULE__}] Process for \"#{name}\" found (#{inspect(pid)})")

        pid
    end
  end
end
