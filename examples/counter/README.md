# Horde Example - Distributed Counters

Example application that demonstrates using [Horde] (https://github.com/derekkraan/horde) to manage a colleciton of processes across multiple nodes.

To see it in action, start up three nodes locally with `iex`. From the root of this application, run each of the following in its own terminal:

```
> iex -name=count1@127.0.0.1 -S mix
> iex -name=count2@127.0.0.1 -S mix
> iex -name=count3@127.0.0.1 -S mix
```

There is one GenServer (`Worker`) which acts as a simple counter (casting `:increment` increments the count asynchronously and calling `:value` returns the current count).  The `Router` module allows you to increment different counters denoted by and atom `name`.  Internally, `Router` uses `Horde.Registry.lookup` to determine if a `Worker` process for a given `name` exists, and if not starts one.  Then it either calls that process using the PID returned or using the `:via` method as outlined in the Horde documentation.

From one of the terminals openned, you can interact directly with the `Router` using:

```
> Counter.Router.Via.increment(:foo)
> Counter.Router.Via.increment(:foo)
> Counter.Router.Via.value(:foo)
2
```

Or you can use the PID-based method:

```
> Counter.Router.PID.increment(:foo)
> Counter.Router.PID.value(:foo)
1
```

In order to demonstrate race conditions (as mentioned in [https://github.com/derekkraan/horde/issues/22]), there is a `Demo` module that makes sample calls rapidly, which will sometimes catch `Horde.Registry` and `Horde.Supervisor` out of sync due to eventual consistency of the Registry.

```
iex(count1@127.0.0.1)7> Demo.go_via()
3

iex(count1@127.0.0.1)8> Demo.go_via()
** (MatchError) no match of right hand side value: {:error, {:already_started, nil}}
    (routing) lib/router.ex:25: Counter.Router.PID.lookup_and_start_if_needed/1
    (routing) lib/router.ex:45: Counter.Router.Via.increment/1
    (routing) lib/demo.ex:5: Demo.go_via/0
```
