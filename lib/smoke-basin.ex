defmodule SB do
  def adder(inp, i, j) do
    current = elem(inp, i) |> elem(j)
    up = elem(inp, i - 1) |> elem(j)
    down = elem(inp, i + 1) |> elem(j)
    left = elem(inp, i) |> elem(j + 1)
    right = elem(inp, i) |> elem(j - 1)
    [up, down, left, right]
    |> Enum.all?(& String.to_integer(&1) > String.to_integer(current))
    |> then(fn
      :true -> String.to_integer(current)
      :false -> 0
      end)
  end

  def run(path) do
    inp =
      path
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.split(&1, "", trim: true))
      |> Enum.map(& &1)

    [first | _] = inp
    lenEl = length(first)
    firstLast = List.duplicate("9", lenEl + 2)
    lenAll = length(inp)

    inpTuple =
      inp
      |> Enum.reduce([firstLast], fn li, acc -> acc ++ [["9" | li] ++ ["9"]] end)
      |> then(&(&1 ++ [firstLast]))
      |> Enum.map(fn x -> List.to_tuple(x) end)
      |> then(&List.to_tuple(&1))

    points = for i <- 1..lenAll, j <- 1..lenEl, reduce: {} do
      acc -> Tuple.append(acc, adder(inpTuple, i, j))
    end
    Tuple.sum(points)

  end
end

IO.inspect(SB.run("./file12"))
