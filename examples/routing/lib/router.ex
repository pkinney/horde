defmodule Routing.Router.PID do
  require Logger

  def increment(name) do
    lookup_and_start_if_needed(name)
    |> GenServer.cast(:increment)
  end

  def value(name) do
    lookup_and_start_if_needed(name)
    |> GenServer.call(:value)
  end

  def lookup_and_start_if_needed(name) do
    lookup =
      Horde.Registry.lookup(
        Routing.Registry,
        name
      )

    case lookup do
      :undefined ->
        Logger.debug("[#{__MODULE__}] Process not found for \"#{name}\".")

        {:ok, pid} =
          Horde.Supervisor.start_child(
            Routing.RoutingSupervisor,
            {Routing.Worker, name: name}
          )

        Logger.debug("[#{__MODULE__}] New process started for \"#{name}\" (#{inspect(pid)})")

        pid

      [{pid, _}] ->
        Logger.debug("[#{__MODULE__}] Process for \"#{name}\" found (#{inspect(pid)})")

        pid
    end
  end
end

defmodule Routing.Router.Via do
  def increment(name) do
    Routing.Router.PID.lookup_and_start_if_needed(name)
    GenServer.cast(Routing.Worker.via_tuple(name), :increment)
  end

  def value(name) do
    Routing.Router.PID.lookup_and_start_if_needed(name)
    GenServer.call(Routing.Worker.via_tuple(name), :value)
  end
end
