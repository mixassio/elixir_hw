defmodule SS do
  def normalize(dict1, dict2) do
    {_, newDict} = Map.pop(dict1, ["c", "f"])
    {_, newDict} = Map.pop(newDict, ["b", "d"])

    if length(Map.keys(newDict)) == 2 do
      [k1, k2] = Map.keys(newDict)
      [v1, v2] = Map.values(newDict)
      # IO.inspect(newDict)
      # IO.inspect(dict2)
      [k] = MapSet.to_list(MapSet.intersection(MapSet.new(k1), MapSet.new(k2)))
      [v] = MapSet.to_list(MapSet.intersection(MapSet.new(v1), MapSet.new(v2)))
      [k11] = MapSet.to_list(MapSet.difference(MapSet.new(k1), MapSet.new([k])))
      [k22] = MapSet.to_list(MapSet.difference(MapSet.new(k2), MapSet.new([k])))
      [v11] = MapSet.to_list(MapSet.difference(MapSet.new(v1), MapSet.new([v])))
      [v22] = MapSet.to_list(MapSet.difference(MapSet.new(v2), MapSet.new([v])))
      # IO.inspect([k,v, k11, v11, k22, v22])
      dict2 = Map.put(dict2, v, k)
      dict2 = Map.put(dict2, v11, k11)
      dict2 = Map.put(dict2, v22, k22)
      [dict1, dict2]
    else
      [dict1, dict2]
    end
  end

  def decript_w([a, b], [_, _]) do
    [%{["c", "f"] => [a, b]}, %{}]
  end

  def decript_w([a, b, c], [dict1, dict2]) do
    a = MapSet.difference(MapSet.new([a, b, c]), MapSet.new(Map.get(dict1, ["c", "f"])))
    [a] = MapSet.to_list(a)
    dict2 = Map.put(dict2, a, "a")
    [dict1, dict2]
  end

  def decript_w([a, b, c, d], [dict1, dict2]) do
    bd = MapSet.difference(MapSet.new([a, b, c, d]), MapSet.new(Map.get(dict1, ["c", "f"])))
    bd = MapSet.to_list(bd)
    dict1 = Map.put(dict1, ["b", "d"], bd)
    [dict1, dict2]
  end

  def decript_w([a, b, c, d, e], [dict1, dict2]) do
    # IO.inspect([dict1, dict2], label: :dict)
    # IO.inspect([a, b, c, d, e], label: :list)
    # IO.inspect(MapSet.new(Map.keys(dict2)), label: :set1)
    # IO.inspect(MapSet.new([a, b, c, d, e]), label: :set2)
    tail = MapSet.difference(MapSet.new([a, b, c, d, e]), MapSet.new(Map.keys(dict2)))
    # IO.inspect(tail, label: :tail)
    this3 = MapSet.subset?(MapSet.new(Map.get(dict1, ["c", "f"])), tail)
    # IO.inspect(this3, label: :this3)
    this5 = MapSet.subset?(MapSet.new(Map.get(dict1, ["b", "d"])), tail)
    # IO.inspect(this5, label: :this5)

    if this3 do
      dg = MapSet.difference(MapSet.new(tail), MapSet.new(Map.get(dict1, ["c", "f"])))
      dg = MapSet.to_list(dg)
      # IO.inspect(dg, label: :dg)
      dict1 = Map.put(dict1, ["d", "g"], dg)
      normalize(dict1, dict2)
    else
      if this5 do
        # IO.inspect(MapSet.new(Map.get(dict1, ["b", "d"])), label: :k)
        fg = MapSet.difference(MapSet.new(tail), MapSet.new(Map.get(dict1, ["b", "d"])))
        fg = MapSet.to_list(fg)
        # IO.inspect(fg, label: :fg)
        dict1 = Map.put(dict1, ["f", "g"], fg)
        normalize(dict1, dict2)
      else # this2
        if MapSet.size(tail) == 1 do
          [w] = MapSet.to_list(tail)
          [v] = MapSet.to_list(MapSet.difference(MapSet.new([a, b, c, d, e]), MapSet.new(Map.keys(dict2))))
          dict1 = Map.put(dict2, w, v)
          normalize(dict1, dict2)
        else
          [dict1, dict2]
        end
      end
    end
  end

  def decript_w([a,b,c,d,e,f], [dict1, dict2]) do
    IO.inspect([a,b,c,d,e,f], label: :six)
    tail = MapSet.difference(MapSet.new([a, b, c, d, e, f]), MapSet.new(Map.keys(dict2)))
    IO.inspect(tail, label: :tail)
    [dict1, dict2]
  end

  def decript_w(_, [dict1, dict2]), do: [dict1, dict2]
  def decript(inp) do
    inp
    |> Enum.reduce([%{}, %{}], fn x, acc -> decript_w(x, acc) end)
  end

  def run(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " | "))
    |> Enum.map(fn [l1, l2] ->
      [
        String.split(l1, " ", trim: true)
        |> Enum.map(fn str -> String.split(str, "", trim: true) |> Enum.sort() end)
        |> Enum.sort(&(length(&1) < length(&2))),
        String.split(l2, " ", trim: true)
        |> Enum.map(fn str -> String.split(str, "", trim: true) |> Enum.sort() end)
      ]
    end)
    |> Enum.map(fn [inp, _] -> decript(inp) end)
  end
end

IO.inspect(SS.run("./file11"))
