defmodule Origami do
  def fill_matrix(x, y, coords) do
    matrix = Tuple.duplicate(Tuple.duplicate(0, x + 1), y + 1)

    coords
    |> Enum.reduce(matrix, fn [i, j], acc -> new_acc(acc, i, j) end)
  end

  def get_size(matrix), do: {tuple_size(matrix), tuple_size(elem(matrix, 0))}

  def transform(matrix) do
    {rows, elems} = get_size(matrix)
    new_matrix = Tuple.duplicate(Tuple.duplicate(0, rows), elems)

    for i <- 0..(rows - 1), j <- 0..(elems - 1), reduce: new_matrix do
      acc -> new_acc(acc, i, j, elem(elem(matrix, i), j))
    end
  end

  defp new_acc(acc, i, j, value \\ 1) do
    row = elem(acc, j)
    new_row = put_elem(row, i, value)
    put_elem(acc, j, new_row)
  end

  def fold(matrix, :x, line) do
    matrix
    |> transform()
    |> create_matrix(line)
    |> transform()
  end

  def fold(matrix, :y, line) do
    matrix
    |> create_matrix(line)
  end

  def create_matrix(matrix, line) do
    {rows, _} = get_size(matrix)
    new_size = rows - line - 1
    new_matrix = Tuple.duplicate({}, new_size)
    for i <- 1..new_size, reduce: new_matrix do
      acc -> put_elem(acc, line - i, add_two_row(elem(matrix, line - i), elem(matrix, line + i)))
    end
  end

  def add_two_row(row1, row2) do
    for i <- 0..tuple_size(row1)-1, reduce: {} do
      acc -> Tuple.append(acc, elem(row1, i) + elem(row2, i))
    end
  end

  def run(path) do
    %{:x => x, :y => y, :coords => coords} =
      path
      |> File.stream!()
      |> Enum.map(&String.trim/1)
      |> Enum.reduce(
        %{:x => 0, :y => 0, :coords => []},
        fn el, %{:x => x, :y => y, :coords => coords} ->
          [f, s] = String.split(el, ",", trim: true) |> Enum.map(&String.to_integer(&1))
          %{:x => max(f, x), :y => max(s, y), :coords => [[f, s] | coords]}
        end
      )

    fill_matrix(x, y, coords)
    |> fold(:x, 655)
    # |> fold(:y, 447)
    # |> fold(:x, 327)
    # |> fold(:y, 223)
    # |> fold(:x, 163)
    # |> fold(:y, 111)
    # |> fold(:x, 81)
    # |> fold(:y, 55)
    # |> fold(:x, 40)
    # |> fold(:y, 27)
    # |> fold(:y, 13)
    # |> fold(:y, 6)
    |> Tuple.to_list()
    |> Enum.reduce(0, fn tpl, acc ->
      acc + (Tuple.to_list(tpl) |> Enum.count(& &1> 0))
    end)
  end
end

IO.inspect(Origami.run("./file17"))
