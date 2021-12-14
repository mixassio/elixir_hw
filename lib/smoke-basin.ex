defmodule SB do
  def get_neighbours(inp, i, j) do
    current = inp |> elem(i) |> elem(j)
    up = inp |> elem(i - 1) |> elem(j)
    down = inp |> elem(i + 1) |> elem(j)
    left = inp |> elem(i) |> elem(j + 1)
    right = inp |> elem(i) |> elem(j - 1)

    %{
      :current => current,
      :up => up,
      :down => down,
      :left => left,
      :right => right
    }
  end

  def adder(inp, i, j) do
    %{
      current: current,
      up: up,
      down: down,
      left: left,
      right: right
    } = get_neighbours(inp, i, j)

    [up, down, left, right]
    |> Enum.all?(&(String.to_integer(&1) > String.to_integer(current)))
    |> if(do: {{i, j}, String.to_integer(current) + 1}, else: {{0, 0}, 0})
  end

  def transformData(inp, firstLast) do
    inp
    |> Enum.reduce([firstLast], fn li, acc -> acc ++ [["9" | li] ++ ["9"]] end)
    |> then(&(&1 ++ [firstLast]))
    |> Enum.map(fn x -> List.to_tuple(x) end)
    |> then(&List.to_tuple(&1))
  end

  def size_basine(inpTuple, {i, j}, mapset) do
    %{
      current: current,
      up: up,
      down: down,
      left: left,
      right: right
    } = get_neighbours(inpTuple, i, j)

    [{up, {i - 1, j}}, {down, {i + 1, j}}, {left, {i, j + 1}}, {right, {i, j - 1}}]
    |> Enum.reduce(MapSet.put(mapset, {i, j}), fn {value, coord}, acc ->
      if((String.to_integer(current) < String.to_integer(value)) and String.to_integer(value) < 9,
        do: MapSet.union(acc, size_basine(inpTuple, coord, acc)),
        else: acc
      )
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
    inpTuple = transformData(inp, firstLast)

    points =
      for i <- 1..lenAll, j <- 1..lenEl, reduce: {} do
        acc -> Tuple.append(acc, adder(inpTuple, i, j))
      end

    result =
      points
      |> Tuple.to_list()
      |> Enum.reduce({[], 0}, fn {coord, value}, acc ->
        {[coord | elem(acc, 0)], elem(acc, 1) + value}
      end)

    elem(result, 1) # answer for part1

    elem(result, 0)
    |> Enum.filter(&(&1 != {0, 0}))
    |> Enum.map(&size_basine(inpTuple, &1, MapSet.new()))
    |> Enum.map(&MapSet.size(&1))
    |> Enum.sort(&(&1 >= &2))
    |> IO.inspect(limit: :infinity)
    |> then(fn [x, y, z | _] -> x * y * z end) # answer for part2
  end
end

IO.inspect(SB.run("./file12"))
