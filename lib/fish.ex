defmodule Fish do

  def next_timer(0), do: {6, 8}
  def next_timer(n), do: {n - 1, 0}

  def day_tick(fish, 0), do: fish
  def day_tick(fish, days) do
    IO.inspect(days)
    fish
      |> Enum.reduce({[], []}, fn n, {oldFish, newFish} ->
        case next_timer(n) do
          {n, 0} -> {oldFish ++ [n], newFish}
          {6, 8} -> {oldFish ++ [6], newFish ++ [8]}
        end
      end)
      |> then(fn {oldFish, newFish} -> oldFish ++ newFish end)
      |> day_tick(days - 1)
  end

  def run(path, days) do
    path
      |> File.stream!()
      # |> Stream.map(&String.trim/1)
      |> Stream.map(&String.split(&1, ","))
      |> Enum.to_list()
      |> List.flatten()
      |> Enum.map(&String.to_integer(&1))
      |> day_tick(days)
      |> length()
  end
end

IO.inspect(Fish.run("./file7", 80))
