defmodule HW.FileParse do

  def load_lines!(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.replace(&1, "\n", ""))
  end

  def large_lines!(path, size) do
    path
    |> load_lines!()
    |> Enum.filter(&(String.length(&1) > size))
  end

  def lines_lenghts!(path) do
    path
    |> load_lines!()
    |> Enum.map(&(String.length(&1)))
  end

  defp check_size(str, acc) when byte_size(acc) < byte_size(str), do: str
  defp check_size(_, acc), do: acc

  def longest_line!(path) do
    path
    |> load_lines!()
    |> Enum.reduce("", fn x, acc -> check_size(x, acc) end)
  end

  def longest_line_length!(path) do
    path
    |> load_lines!()
    |> Enum.reduce("", fn x, acc -> check_size(x, acc) end)
    |> String.length()
  end

  def words_per_line!(path) do
    path
    |> load_lines!()
    |> Enum.map(&(String.split(&1)))
    |> Enum.map(fn a ->
      a |> Enum.reduce(0, fn _, acc -> acc + 1 end)
      end)
  end

end

IO.inspect(HW.FileParse.large_lines!("./file", 10))
IO.inspect(HW.FileParse.lines_lenghts!("./file"))
IO.inspect(HW.FileParse.longest_line!("./file"))
IO.inspect(HW.FileParse.longest_line_length!("./file"))
IO.inspect(HW.FileParse.words_per_line!("./file"))
