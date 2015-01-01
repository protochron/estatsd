defmodule Estatsd.UtilsTest do
  use ExUnit.Case

  test 'sums a set' do
    assert Estatsd.Utils.sum([1,2,3]) == 6
  end

  test 'finds the mean of a set of numbers' do
    assert Estatsd.Utils.mean([1,2,3]) == 2
  end

  test 'finds the max of a set of numbers' do
    assert Estatsd.Utils.max([1,2,3]) == 3
  end

  test 'finds the min of a set of numbers' do
    assert Estatsd.Utils.min([1,2,3]) == 1
  end
end
