defmodule Whole do
  def counter(li, co) do
    Enum.map(co..1, fn n -> Enum.reduce(li, 0, fn x, acc -> acc + Kernel.abs(n - x)  end) end)
  end
  def run(path) do
    path
      |> File.stream!()
      |> Stream.map(&String.split(&1, ","))
      |> Enum.to_list()
      |> List.flatten()
      |> Enum.map(&String.to_integer(&1))
      |> then(&counter(&1, Enum.max(&1)))
      |> Enum.min()
  end
end

IO.inspect(Whole.run("./file8"))
