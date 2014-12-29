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

end
