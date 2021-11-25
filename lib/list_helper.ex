defmodule HW.ListHelper do
  @moduledoc """
  practicum from book elixir in action
  """

  @doc """
  length list
  ## Examples
      iex> HW.ListHelper.lengthList([1,2,3])
      3
      iex> HW.ListHelper.lengthList([])
      0
  """
  @spec lengthList(list()) :: number()
  def lengthList([]), do: 0
  def lengthList([_ | tail]) do
    lengthList(tail) + 1
  end

  @doc """
  range list
  ## Examples
      iex> HW.ListHelper.rangeList(1, 5)
      [1,2,3,4,5]
      iex> HW.ListHelper.rangeList(5, 1)
      []
      iex> HW.ListHelper.rangeList(5, 5)
      [5]
  """
  @spec rangeList(number(), number()) :: list()
  def rangeList(a, a), do: [a]
  def rangeList(a, b) when a > b, do: []
  def rangeList(a, b) do
    [a | rangeList(a + 1, b)]
  end

  @doc """
  only positive elements
  ## Examples
      iex> HW.ListHelper.positiveList([])
      []
      iex> HW.ListHelper.positiveList([1,2,3])
      [1,2,3]
      iex> HW.ListHelper.positiveList([1,-5,8,-6,0])
      [1,8]
  """
  @spec positiveList(list()) :: list()
  def positiveList([]), do: []
  def positiveList([head | tail]) when head > 0 do
    [head | positiveList(tail)]
  end
  def positiveList([head | tail]) when head <= 0 do
    positiveList(tail)
  end

end
