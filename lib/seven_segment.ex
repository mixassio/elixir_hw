defmodule SS2 do

  def digitals(["a", "b", "c", "e", "f", "g"]), do: 0
  def digitals(["c","f"]), do: 1
  def digitals(["a", "c", "d", "e", "g"]), do: 2
  def digitals(["a", "c", "d", "f", "g"]), do: 3
  def digitals(["b", "c", "d", "f"]), do: 4
  def digitals(["a", "b", "d", "f", "g"]), do: 5
  def digitals(["a", "b", "d", "e", "f", "g"]), do: 6
  def digitals(["a", "c", "f"]), do: 7
  def digitals(["a", "b", "c", "d", "e", "f", "g"]), do: 8
  def digitals(["a", "b", "c", "d", "f", "g"]), do: 9

  def normalize(newDict, dict2) do
    if length(Map.keys(newDict)) == 2 do
      [k1, k2] = Map.keys(newDict)
      [v1, v2] = Map.values(newDict)
      [k] = MapSet.to_list(MapSet.intersection(MapSet.new(k1), MapSet.new(k2)))
      [v] = MapSet.to_list(MapSet.intersection(MapSet.new(v1), MapSet.new(v2)))
      [k11] = MapSet.to_list(MapSet.difference(MapSet.new(k1), MapSet.new([k])))
      [k22] = MapSet.to_list(MapSet.difference(MapSet.new(k2), MapSet.new([k])))
      [v11] = MapSet.to_list(MapSet.difference(MapSet.new(v1), MapSet.new([v])))
      [v22] = MapSet.to_list(MapSet.difference(MapSet.new(v2), MapSet.new([v])))
      dict2 = Map.put(dict2, v, k)
      dict2 = Map.put(dict2, v11, k11)
      dict2 = Map.put(dict2, v22, k22)
      [newDict, dict2]
    else
      [newDict, dict2]
    end
  end

  def normalize2([dict1, dict2]) do
    allNumbers = ["a", "b", "c", "d", "e", "f", "g"]
    known_keys = Map.keys(dict2)
    known_values = Map.values(dict2)
    [key] = MapSet.to_list(MapSet.difference(MapSet.new(allNumbers), MapSet.new(known_keys)))
    [value] = MapSet.to_list(MapSet.difference(MapSet.new(allNumbers), MapSet.new(known_values)))
    dict2 = Map.put(dict2, key, value)
    [dict1, dict2]
  end

  def decript_w2([a, b], [_, _]) do
    [%{["c", "f"] => [a, b]}, %{}]
  end

  def decript_w3([a, b, c], [dict1, dict2]) do
    a = MapSet.difference(MapSet.new([a, b, c]), MapSet.new(Map.get(dict1, ["c", "f"])))
    [a] = MapSet.to_list(a)
    dict2 = Map.put(dict2, a, "a")
    [dict1, dict2]
  end

  def decript_w4([a, b, c, d], [dict1, dict2]) do
    bd = MapSet.difference(MapSet.new([a, b, c, d]), MapSet.new(Map.get(dict1, ["c", "f"])))
    bd = MapSet.to_list(bd)
    dict1 = Map.put(dict1, ["b", "d"], bd)
    [dict1, dict2]
  end

  def descript_d3([a, b, c, d, e], [dict1, dict2]) do
    tail = MapSet.difference(MapSet.new([a, b, c, d, e]), MapSet.new(Map.keys(dict2)))
    dg = MapSet.difference(MapSet.new(tail), MapSet.new(Map.get(dict1, ["c", "f"])))
    dg = MapSet.to_list(dg)
    dict1 = Map.put(dict1, ["d", "g"], dg)
    {_, newDict} = Map.pop(dict1, ["c", "f"])
    {_, newDict} = Map.pop(newDict, ["b", "d"])
    [_, dict2] = normalize(newDict, dict2)
    [dict1, dict2]
  end

  def descript_d5([a, b, c, d, e], [dict1, dict2]) do
    tail = MapSet.difference(MapSet.new([a, b, c, d, e]), MapSet.new(Map.keys(dict2)))
    fg = MapSet.difference(MapSet.new(tail), MapSet.new(Map.get(dict1, ["b", "d"])))
    fg = MapSet.to_list(fg)
    dict1 = Map.put(dict1, ["f", "g"], fg)
    {_, newDict} = Map.pop(dict1, ["c", "f"])
    {_, newDict} = Map.pop(newDict, ["b", "d"])
    [_, dict2] = normalize(newDict, dict2)
    [dict1, dict2]
  end

  def descript_d2([a, b, c, d, e], [dict1, dict2]) do
    tail = MapSet.difference(MapSet.new([a, b, c, d, e]), MapSet.new(Map.keys(dict2)))
    ce = MapSet.to_list(tail)

    cf = Map.get(dict1, ["c", "f"])
    newdict = %{["c", "f"] => cf, ["c", "e"] => ce}
    [_, dict2] = normalize(newdict, dict2)
    dict1 = Map.put(dict1, ["c", "e"], ce)
    normalize2([dict1, dict2])
  end

  def descript_z(li, [dict1, dict2]) do
    [words2] = Enum.filter(li, fn el -> length(el) == 2 end)
    [words3] = Enum.filter(li, fn el -> length(el) == 3 end)
    [words4] = Enum.filter(li, fn el -> length(el) == 4 end)
    words5 = Enum.filter(li, fn el -> length(el) == 5 end)
    [dict1, dict2] = decript_w2(words2, [dict1, dict2])
    [dict1, dict2] = decript_w3(words3, [dict1, dict2])
    [dict1, dict2] = decript_w4(words4, [dict1, dict2])

    [digital3] =
      words5
      |> Enum.map(fn ws5 ->
        this3? = MapSet.subset?(MapSet.new(Map.get(dict1, ["c", "f"])), MapSet.new(ws5))

        case this3? do
          true -> ws5
          false -> nil
        end
      end)
      |> Enum.filter(fn el -> el != nil end)

    [digital5] =
      words5
      |> Enum.map(fn ws5 ->
        this3? = MapSet.subset?(MapSet.new(Map.get(dict1, ["b", "d"])), MapSet.new(ws5))

        case this3? do
          true -> ws5
          false -> nil
        end
      end)
      |> Enum.filter(fn el -> el != nil end)

    [digital2] =
      MapSet.to_list(MapSet.difference(MapSet.new(words5), MapSet.new([digital3, digital5])))
    [dict1, dict2] = descript_d5(digital5, [dict1, dict2])
    [dict1, dict2] = descript_d3(digital3, [dict1, dict2])
    descript_d2(digital2, [dict1, dict2])
  end

  def decript(inp, outp) do
    [_, descriptors] = inp
    |> descript_z([%{}, %{}])

    outp
    |> Enum.map(fn outW -> Enum.map(outW, fn w -> Map.get(descriptors, w) end) |> Enum.sort() end)
    |> Enum.map(fn dg -> digitals(dg) end)
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
    |> Enum.map(fn [inp, outp] -> decript(inp, outp) end)
    |> List.flatten()
    |> Enum.filter(fn x -> x in [1,4,7,8] end)
    |> length()
  end
end

IO.inspect(SS2.run("./file10"))
