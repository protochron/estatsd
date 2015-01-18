defmodule Estatsd.Backend.GraphiteTest do
  use ExUnit.Case, async: true
  use Timex

  alias Estatsd.Backend.Graphite

  setup_all do
    start_time = Date.convert(Date.now, :secs)
    backend = %Graphite { flush_interval: 60,
      last_flush: start_time,
      last_exception: start_time
    }
    {:ok, backend: backend, start_time: start_time}
  end

  test "creates a Graphite backend" do
    graphite = Graphite.new([flush_interval: 60])
    assert graphite.global_prefix == "stats"
    assert graphite.global_suffix == ""
    assert graphite.counter_prefix == "counter"
    assert graphite.gauge_prefix == "gauge"
    assert graphite.set_prefix == "set"
    assert graphite.timer_prefix == "timer"
  end

end

