defmodule Hello do
  @moduledoc """
  docs inside module
  """
  @default :world

  @doc """
  func with parameters
  ## Examples
      iex> Hello.world("Misha")
      "Hello Misha"
  """
  @spec world(charlist()) :: charlist()
  def world(s), do: "Hello #{s}"

  @doc """
  func with default param
  ## Examples
      iex> Hello.world()
      "Hello world"
  """
  @spec world() :: charlist()
  def world, do: world(@default)
end
