defmodule Estatsd.Backend.GraphiteTest do
  use ExUnit.Case, async: true
  use Timex

  alias Estatsd.Backend.Graphite

  def simple_graphite do
    %Graphite { flush_interval: 60,
      last_flush: meta[:start_time],
      last_exception: meta[start_time]
    }
  end

  test "creates a Graphite backend", meta do
    graphite = Graphite.new([flush_interval: 60])
    assert graphite == simple_graphite
  end
end

