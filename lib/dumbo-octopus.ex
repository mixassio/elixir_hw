defmodule Octopus do

  def getNeighbours(0, 0), do: []
  def getNeighbours(i, j) do
    top = to_string(i - 1) <> to_string(j)
    topleft = to_string(i - 1) <> to_string(j - 1)
    left = to_string(i) <> to_string(j - 1)
    downleft = to_string(i + 1) <> to_string(j - 1)
    down = to_string(i + 1) <> to_string(j)
    downright = to_string(i + 1) <> to_string(j + 1)
    right = to_string(i) <> to_string(j + 1)
    topright = to_string(i - 1) <> to_string(j + 1)
    [top, topleft, left, downleft, down, downright, right, topright]
  end

  def start({value, {i, j}}) do
    neighbours = getNeighbours(i, j)
    spawn(fn -> loop({value, neighbours, 0, {i, j}}) end)
  end

  def value(server_pid) do
    send(server_pid, {:value, self()})

    receive do
      {:response, value} ->
        value
    end
  end

  def add(server_pid, storePIDs), do: send(server_pid, {:add, storePIDs})

  defp loop({current_value, neighbours, counter, coords}) do
    new_value =
      receive do
        {:value, caller} ->
          send(caller, {:response, {current_value, counter, coords}})
          {current_value, neighbours, counter, coords}

        {:add, storePIDs} ->
          addEnergy(current_value, neighbours, counter, coords, storePIDs) # return???
      end

    loop(new_value)
  end

  def addEnergy(current_value, neighbours, counter, coords, storePIDs) when current_value >= 9 do
    IO.inspect({current_value, neighbours, counter, coords}, label: :addEnergy)
    neighbours
    |> Enum.map(fn nb -> Map.get(storePIDs, nb, Map.get(storePIDs, "00")) end)
    |> IO.inspect(label: :forsend)
    |> Enum.map(fn pid -> Octopus.add(pid, storePIDs) end) # Is it happend???

    {0, neighbours, counter + 1, coords}
  end

  def addEnergy(current_value, neighbours, counter, coords, _) do
    IO.inspect({current_value, neighbours, counter, coords}, label: :addEnergySimple)
    {current_value + 1, neighbours, counter, coords}
  end

  def run(path, steps \\ 1) do
    inp =
      path
      |> File.stream!()
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.split(&1, "", trim: true))

    storePIDs =
      inp
      |> Enum.with_index(fn li, rowIdx ->
        Enum.with_index(li, fn el, elIdx ->
          pid = Octopus.start({String.to_integer(el), {rowIdx + 1, elIdx + 1}})
          key = to_string(rowIdx + 1) <> to_string(elIdx + 1)
          {key, pid}
        end)
      end)
      |> List.flatten()
      |> Enum.reduce(%{"00" => Octopus.start({0, {0, 0}})}, fn {key, pid}, acc ->
        Map.put(acc, key, pid)
      end)

    1..steps
    |> Enum.map(fn _ ->
      storePIDs |> Map.values() |> Enum.map(fn pid -> Octopus.add(pid, storePIDs) end)
    end)

    storePIDs |> Map.values() |>  Enum.map(fn pid -> Octopus.value(pid) end) |> IO.inspect()

    # IO.inspect(storePIDs)

    # Octopus.value(Map.get(storePIDs, "22", 3))
  end
end

IO.inspect(Octopus.run("./file15"))
