defmodule HW3 do

  def ws(str, counter \\ 0), do: IO.inspect(str)


  def run2(path) do
    path
    |> File.stream!([], 1)
    |> Enum.to_list()
    |> Enum.filter(fn x -> x == " " or x == "\n" end)
    |> length()
    |> then(& &1 + 1)
  end


  def run1(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.split(&1, " "))
    |> Enum.to_list()
    |> List.flatten()
    |> length()
  end
end

IO.inspect(HW3.run2("./file"))
