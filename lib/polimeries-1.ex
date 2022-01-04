defmodule Polimeries do
  def change_letters(init, _, 0), do: init
  def change_letters(init, template, count) do
    IO.inspect(count, label: :count)

    result =
      init
      |> Stream.chunk_every(2, 1)
      |> Stream.map(fn
        [first] -> [first]
        [first, second] -> [first, Map.get(template, first ++ second, '')]
      end)
      |> Stream.flat_map(& &1)

    change_letters(result, template, count - 1)
  end

  def run(path) do
    template =
      path
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.split(&1, " -> ", trim: true))
      |> Enum.reduce(%{}, fn [k, v], acc ->
        Map.put(acc, String.to_charlist(k), String.to_charlist(v))
      end)

    'VFHKKOKKCPBONFHNPHPN'
    |> Stream.map(&[&1])
    |> change_letters(template, 10)
    |> Enum.join()
    # |> IO.inspect()
    # |> Enum.frequencies()
    |> String.to_charlist()
    |> Enum.reduce(%{}, fn l, acc -> Map.update(acc, l, 1, fn ex_val -> ex_val + 1 end) end)
  end
end

IO.inspect(Polimeries.run("./file18"))
