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
    spawn(fn -> loop({value, neighbours, 0, {i, j}, false}) end)
  end

  def value(server_pid) do
    send(server_pid, {:value, self()})

    receive do
      {:response, value} ->
        value
    end
  end

  def add(server_pid, storePIDs), do: send(server_pid, {:add, storePIDs})

  def reload(server_pid) do
    send(server_pid, {:reload, self()})

    receive do
      {:afterstep, value} -> value
    end
  end

  defp loop({current_value, neighbours, counter, coords, lights?}) do
    new_value =
      receive do
        {:value, caller} ->
          send(caller, {:response, {current_value, counter, coords}})
          {current_value, neighbours, counter, coords, lights?}

        {:add, storePIDs} ->
          addEnergy(current_value, neighbours, counter, coords, lights?, storePIDs)

        {:reload, caller} ->
          after_step = checkState({current_value, neighbours, counter, coords, lights?})
          send(caller, {:afterstep, {current_value, coords}})
          after_step
      end

    loop(new_value)
  end

  def addEnergy(current_value, neighbours, counter, coords, false, storePIDs)
      when current_value >= 9 do
    neighbours
    |> Enum.map(fn nb -> Map.get(storePIDs, nb, Map.get(storePIDs, "00")) end)
    |> Enum.map(fn pid -> Octopus.add(pid, storePIDs) end)

    {0, neighbours, counter + 1, coords, true}
  end

  def addEnergy(current_value, neighbours, counter, coords, true, storePIDs)
      when current_value >= 9 do
    neighbours
    |> Enum.map(fn nb -> Map.get(storePIDs, nb, Map.get(storePIDs, "00")) end)
    |> Enum.map(fn pid -> Octopus.add(pid, storePIDs) end)

    {0, neighbours, counter, coords, true}
  end

  def addEnergy(current_value, neighbours, counter, coords, false, _) do
    {current_value + 1, neighbours, counter, coords, false}
  end

  def addEnergy(current_value, neighbours, counter, coords, true, _) do
    {current_value, neighbours, counter, coords, true}
  end

  def checkState({current_value, neighbours, counter, coords, true}),
    do: {0, neighbours, counter, coords, false}

  def checkState({current_value, neighbours, counter, coords, false}),
    do: {current_value, neighbours, counter, coords, false}

  def checkCurrentStates(state) do
    IO.inspect(state, label: :state)
    onlyZeros = state
    |> Enum.filter(fn {_, coords} -> coords != {0,0} end)
    |> Enum.map(fn {value, _} -> value end)
    |> IO.inspect(label: :afterfilter)
    # считает верно но инспект на 255 (предпоследнем) шаге выдал afterfilter: '\b\b\b\b\b\b\b\b\b\b\t\b\b\b\a\b\b\b\b\b\b\b\t\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\t\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\t\b\b\b\b\b\b\b\b\b\b\b\b\b\b'
    |> Enum.filter(fn z -> z == 0 end)
    |> IO.inspect(label: :zerous)
    length(state) - 1 == length(onlyZeros)
  end

  def whileLoop(st, storePIDs) do
    current_states =
      storePIDs
      |> Map.values()
      |> Enum.map(fn pid ->
        Octopus.add(pid, storePIDs)
        Process.sleep(5)
        pid
      end)
      |> Enum.map(fn pid ->
        current = Octopus.reload(pid)
        Process.sleep(5)
        current
      end)

    IO.inspect(st, label: :step)

    case checkCurrentStates(current_states) do
      true -> st
      false -> whileLoop(st + 1, storePIDs)
    end
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

    # part 1
    # 1..steps
    # |> Enum.map(fn _ ->
    #   storePIDs
    #   |> Map.values()
    #   |> Enum.map(fn pid ->
    #     Octopus.add(pid, storePIDs)
    #     Process.sleep(10)
    #     pid
    #   end)
    #   |> Enum.map(fn pid ->
    #     current = Octopus.reload(pid)
    #     Process.sleep(10)
    #     current
    #   end)
    #   |> IO.inspect(label: :current_state)
    # end)

    # storePIDs
    # |> Map.values()
    # |> Enum.map(fn pid -> Octopus.value(pid) end)
    # |> Enum.filter(fn {_, _, x} -> x != {0, 0} end)
    # |> Enum.map(fn {_, counter, _} -> counter end)
    # |> Enum.sum()

    # end part 1

    whileLoop(1, storePIDs)
  end
end

IO.inspect(Octopus.run("./file15", 100))
