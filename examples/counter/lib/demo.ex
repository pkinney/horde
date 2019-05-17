defmodule Demo do
  def go_via() do
    name = UUID.uuid4() |> String.to_atom()
    Counter.Router.Via.increment(name)
    Counter.Router.Via.increment(name)
    Counter.Router.Via.value(name)
    Counter.Router.Via.increment(name)
    Counter.Router.Via.value(name)
  end

  def go_pid() do
    name = UUID.uuid4() |> String.to_atom()
    Counter.Router.PID.increment(name)
    Counter.Router.PID.increment(name)
    Counter.Router.PID.value(name)
    Counter.Router.PID.increment(name)
    Counter.Router.PID.value(name)
  end
end
