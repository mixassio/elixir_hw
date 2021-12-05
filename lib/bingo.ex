defmodule AdventCode do
  def addRow(matrix) do
    transform = for i <- 0..4, j <- matrix, do: elem(List.to_tuple(j), i)
    matrix ++ createStruct(transform)
  end

  def createStruct([]), do: []

  def createStruct([a1, a2, a3, a4, a5 | tail]) do
    [[a1, a2, a3, a4, a5] | createStruct(tail)]
  end

  def resultWin([]), do: {:nowin, []}
  def resultWin(matrixWin), do: {:win, matrixWin}

  def filterWinMatrix([matrix], matrix, [cur | _]), do: {matrix, cur}
  def filterWinMatrix(gameMap, matrix, moveList) do
    gameMap
      |> Enum.filter(fn mtrx -> matrix != mtrx end)
      |> game(moveList)
  end

  def checkWinner(gameMap) do
    gameMap
    |> Enum.filter(fn matrix -> ["x", "x", "x", "x", "x"] in matrix end)
    |> resultWin()
  end

  def game(gameMap, moveList) do
    [move | tail] = moveList

    newGameMap =
      gameMap
      |> Enum.map(fn l ->
        Enum.map(l, fn
          els ->
            Enum.map(els, fn
              ^move -> "x"
              el -> el
            end)
        end)
      end)

    case checkWinner(newGameMap) do
      {:win, [matrixWin | _]} ->  filterWinMatrix(newGameMap, matrixWin, moveList)#-> {matrixWin, move} part 1
      {:nowin, _} -> game(newGameMap, tail)
    end
  end

  def bingo(path) do
    [input | tail] =
      path
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.split(&1, " ", trim: true))
      |> Stream.filter(&(List.last(&1) != nil))
      |> Enum.to_list()

    gameMap = tail |> createStruct() |> Enum.map(&addRow(&1))
    moveList = input |> then(fn [x | _] -> String.split(x, ",") end)

    {matrix, currentMove} = game(gameMap, moveList)

    matrix
    |> List.flatten()
    |> Enum.filter(fn x -> x != "x" end)
    |> Enum.map(&String.to_integer(&1))
    |> Enum.reduce(0, fn x, acc -> acc + x end)
    |> then(fn x -> x / 2 * String.to_integer(currentMove) end)
  end
end

IO.inspect(AdventCode.bingo("./file5"))
