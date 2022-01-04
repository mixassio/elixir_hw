defmodule Polimeries2 do
  @spec run(binary(), non_neg_integer()) :: non_neg_integer()
  def run(file, steps \\ 10) do
    pairs =
      for <<p1::8, p2::8, " -> ", to_insert::8>> <- String.split(File.read!(file), "\n"),
          into: %{},
          do: {[p1, p2], to_insert}


    'VFHKKOKKCPBONFHNPHPN'
    |> Enum.chunk_every(2, 1)
    |> IO.inspect()
    |> Enum.frequencies()
    |> IO.inspect()
    |> Stream.iterate(&step(&1, pairs))
    |> Enum.at(steps)
    |> IO.inspect(label: :tut)
    |> Enum.reduce(%{}, fn {[char|_], count}, counts ->
        Map.update(counts, char, count, &(&1 + count))
    end)
  end

  defp step(freqs, pairs) do
    freqs
    |> Enum.flat_map(fn
      {[c1, c2] = pair, count} -> [{[c1, pairs[pair]], count}, {[pairs[pair], c2], count}]
      single -> List.wrap(single)
    end)
    |> Enum.reduce(%{}, fn {c, count}, counts ->
      Map.update(counts, c, count, &(&1 + count)) end
    )
  end
end

IO.inspect(Polimeries2.run("./file18", 40))
