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

  test "creates a Graphite backend", meta do
    graphite = Graphite.new([flush_interval: 60])
    assert graphite == meta[:backend]
  end
end

