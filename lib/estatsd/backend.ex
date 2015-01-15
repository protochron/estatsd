defmodule Estatsd.Backend do
  use Behaviour

  defcallback new(config :: Map, start_time :: Integer) :: Map
  defcallback send_stats(stats :: Map, config :: Map, backend :: Map) :: Map
end
