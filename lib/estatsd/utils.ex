defmodule Estatsd.Utils do

  def sum(list) do
    Enum.sum(list)
  end

  def mean(list) do
    Enum.sum(list) / Enum.count(list)
  end

  def max(list) do
    Enum.max(list)
  end

  def min(list) do
    Enum.min(list)
  end

  def median(list) do
    sorted = Enum.sort(list)
    middle = (Enum.count(list) - 1) / 2
    f_middle = Float.floor(middle) |> Kernel.trunc
    {:ok, m1} = Enum.fetch(sorted, f_middle)
    if middle > f_middle do
      {:ok, m2} = Enum.fetch(sorted, f_middle+1)
      mean([m1,m2])
    else
      m1
    end
  end
end
