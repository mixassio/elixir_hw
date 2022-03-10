defmodule SyntaxScoring do

  def check(_, {d, acc, false}), do: {d, acc, false}
  Enum.each(["}", ")", "]", ">"], fn i ->
    def check(unquote(i), {0, [], _}), do: {0, [], false}
    def check(unquote(i), {count, [last | tail], true}) do
      keys = %{"}" => "{", ")" => "(", "]" => "[", ">" => "<"}
      penalty = %{"}" => 1197, ")" => 3, "]" => 57, ">" => 25137}
      case keys[unquote(i)] == last do
        true -> {count, tail, true}
        false -> {count + penalty[unquote(i)], tail, false}
      end
    end
  end)
  Enum.each(["{", "(", "[", "<"], fn i ->
    def check(unquote(i), {count, brackets, true}), do: {count, [unquote(i) | brackets], true}
  end)

  def get_penalty(li) do
    li
    |> Enum.reduce({0, [], true}, fn x, acc -> check(x, acc) end)
  end

  def run(path) do
    result =
      path
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.split(&1, "", trim: true))
      |> Enum.map(&get_penalty(&1))

    result
      |> Enum.map(& elem(&1, 0))
      |> Enum.sum() # answer part1

    penalty = %{"(" => 1, "[" => 2, "{" => 3, "<" => 4}

    result
      |> Enum.filter(& elem(&1, 0) == 0)
      |> Enum.map(& elem(&1, 1) |> Enum.reduce(0, fn x, acc -> acc * 5 + penalty[x] end))
      |> Enum.sort()
      |> List.to_tuple()
      |> then(fn x -> elem(x, div(tuple_size(x), 2)) end) #answer part2
  end
end

IO.inspect(SyntaxScoring.run("./file14"))
