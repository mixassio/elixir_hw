defmodule Polimeries do

  # First option, run for part 1, for 10 steps. Not run to 40 step
  def change_letters(init, _, 0), do: init
  def change_letters(init, template, count) do
    IO.inspect(count, label: :count)
    result =
      init
      |> Stream.map(&[&1])
      |> Enum.map_reduce([], fn x, acc -> {[acc ++ x, x], x} end)
      |> then(&elem(&1, 0))
      |> Enum.map(fn [first, second] -> [Map.get(template, first, ''), second] end)
      |> List.flatten()

    change_letters(result, template, count - 1)
  end

  # я думал так будет быстрее, а на самом деле ещё медленнее
  def fast(result, <<one>>, template), do: result <> to_string([one])
  def fast(result, <<first, second, rest::binary>>, template) do
    new_letter = Map.get(template, [first] ++ [second], '')
    new_result = result <> to_string([first]) <> to_string([new_letter])
    fast(new_result, to_string([second]) <> rest, template)
  end


  def faster(init, _, 0), do: init
  def faster(init, template, count) do
    IO.inspect(count, label: :count)
    result = fast("", init, template)
    faster(result, template, count - 1)
  end

  def run(path) do
    template =
      path
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.split(&1, " -> ", trim: true))
      |> Enum.reduce(%{}, fn [k, v], acc ->
        Map.put(acc, String.to_charlist(k), String.to_charlist(v))
        # Map.put(acc, k, v)
      end)

    # 'VFHKKOKKCPBONFHNPHPN'
    # |> change_letters(template, 1)
    # |> Enum.reduce(%{}, fn l, acc -> Map.update(acc, l, 1, fn ex_val -> ex_val + 1 end) end)

    "VFHKKOKKCPBONFHNPHPN"
    |> faster(template, 40)
    |> String.to_charlist()
    |> Enum.reduce(%{}, fn l, acc -> Map.update(acc, l, 1, fn ex_val -> ex_val + 1 end) end)
  end
end

IO.inspect(Polimeries.run("./file18"))
