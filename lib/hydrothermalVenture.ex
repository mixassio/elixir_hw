defmodule AdventCode2 do
  def createRange([{a, b}, {a, c}]) do
    Enum.to_list(b..c)
    |> Enum.map(fn x -> {a, x} end)
  end

  def createRange([{a, b}, {c, b}]) do
    Enum.to_list(a..c)
    |> Enum.map(fn x -> {x, b} end)
  end

  def run(path) do
    variants = path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " -> ", trim: true))
    |> Stream.map(fn [a, b] ->
      [x1, y1] = String.split(a, ",")
      [x2, y2] = String.split(b, ",")

      [
        {String.to_integer(x1), String.to_integer(y1)},
        {String.to_integer(x2), String.to_integer(y2)}
      ]
    end)
    |> Stream.filter(fn [{x1, y1}, {x2, y2}] -> x1 == x2 or y1 == y2 end)
    |> Enum.to_list()
    |> Enum.map(&createRange(&1))
    |> List.flatten()
    |> Enum.reduce(%{}, fn x, acc ->
      Map.update(acc, x, 1, fn existing_value -> existing_value + 1 end)
    end)

    more2 = for {key, value} <- variants, value >= 2, into: %{}, do: {key, value}

    more2
      |> Map.keys()
      |> length()
  end
end

IO.inspect(AdventCode2.run("./file6"))
