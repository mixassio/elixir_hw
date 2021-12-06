defmodule Fish do

  def day_tick(fish, 0), do: fish
  def day_tick(fish, days) do
    IO.inspect(fish)
    fish
      |> Map.to_list()
      |> Enum.reduce(%{}, fn
        {7, v}, acc -> Map.update(acc, 6, v, &(&1 + v))
        {0, v}, acc -> Map.merge(Map.update(acc, 6, v, &(&1 + v)), %{8 => v})
        {n, v}, acc -> Map.put(acc, n-1, v)
      end)
      |> day_tick(days - 1)
  end

  def run(path, days) do
    path
      |> File.stream!()
      |> Stream.map(&String.split(&1, ","))
      |> Enum.to_list()
      |> List.flatten()
      |> Enum.map(&String.to_integer(&1))
      |> Enum.reduce(%{}, fn n, acc -> Map.update(acc, n, 1, &(&1 + 1)) end)
      |> day_tick(days)
      |> Map.values()
      |> Enum.sum()
  end
end

IO.inspect(Fish.run("./file7", 256))
