defmodule Demo do
  def go_via() do
    name = UUID.uuid4() |> String.to_atom()
    Routing.Router.Via.increment(name)
    Routing.Router.Via.increment(name)
    Routing.Router.Via.value(name)
    Routing.Router.Via.increment(name)
    Routing.Router.Via.value(name)
  end

  def go_pid() do
    name = UUID.uuid4() |> String.to_atom()
    Routing.Router.PID.increment(name)
    Routing.Router.PID.increment(name)
    Routing.Router.PID.value(name)
    Routing.Router.PID.increment(name)
    Routing.Router.PID.value(name)
  end
end
