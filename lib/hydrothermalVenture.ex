defmodule AdventCode2 do

  def createRange([{a, b}, {a, c}]), do: Enum.map(b..c, &{a, &1})
  def createRange([{a, b}, {c, b}]), do: Enum.map(a..c, &{&1, b})
  def createRange([{a, a}, {b, b}]), do: Enum.map(a..b, &{&1, &1})
  def createRange([{a, b}, {b, a}]), do: Enum.zip(a..b, b..a)
  def createRange([{a, b}, {c, d}]), do: Enum.zip(a..c, b..d)

  def run(path) do
    variants =
      path
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
      |> Stream.filter(fn [{x1, y1}, {x2, y2}] ->
        x1 == x2 or y1 == y2 or
        x1 == y1 and x2 == y2 or
        x1 == y2 and y1 == x2 or
        abs(x1 - x2) == abs (y1 - y2)
      end)
      |> Enum.map(&createRange(&1))
      |> List.flatten()
      |> Enum.reduce(%{}, fn x, acc ->
        Map.update(acc, x, 1, fn existing_value -> existing_value + 1 end)
      end)

    # more2 = for {key, value} <- variants, value >= 2, do: key
    # length(more2)

    Enum.count(variants, &match?({_, v} when v >= 2, &1))
  end
end

IO.inspect(AdventCode2.run("./file6"))
