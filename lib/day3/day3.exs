defmodule Day3 do
  import Helpers, only: :functions

  defp get_coordinates(claim) do
    [_, _, xy, wh] = String.split(claim)

    pos = xy
    |> String.replace(":", "")
    |> String.split(",")
    |> Enum.map(&(String.to_integer(&1)))
    dims = wh
    |> String.split("x")
    |> Enum.map(&(String.to_integer(&1)))
    |> Stream.with_index(0)
    |> Enum.map(fn({v, i}) -> v + Enum.at(pos, i) end)

    List.flatten([pos, dims])
  end

  defp get_squares(rec, pos \\ [0, 0], squares \\ []) do
    [x1, y1, x2, y2] = rec
    [row, col] = pos

    end_row = y2 - y1 - 1
    end_col = x2 - x1 - 1

    if row <= end_row do
      new_pos = if col < end_col, do: [row, col + 1], else: [row + 1, 0]
      get_squares(rec, new_pos, squares ++ [[x1 + col, y1 + row]])
    else
      squares
    end
  end

  defp get_all_squares(rects) do
    rects
    |> async_map(&(
      get_coordinates(&1)
      |> get_squares
    ))
  end

  defp flatten_squares(squares) do
    Enum.reduce(squares, [], fn(list, acc) -> acc ++ list end)
  end

  defp get_overlaps(squares) do
    squares -- Enum.uniq(squares)
    |> Enum.uniq
  end

  def part_one(path) do
    readlines(path)
    |> get_all_squares
    |> flatten_squares
    |> get_overlaps
    |> Enum.count
    |> IO.inspect
  end

  def part_two(path) do
    squares = path
    |> readlines
    |> get_all_squares
    overlaps = squares
    |> flatten_squares
    |> get_overlaps
    squares
    |> Stream.with_index(1)
    |> Enum.find(fn({square, _}) ->
      !Enum.any?(square, &(Enum.member?(overlaps, &1)))
    end)
    |> IO.inspect
  end
end

# should return: 4
# Day3.part_one("lib/day3/test.txt")

# should return: {[[5, 5], [6, 5], [5, 6], [6, 6]], 3}
# Day3.part_two("lib/day3/test.txt")

# real input
# time: 162.53s
# Day3.part_one("lib/day3/input.txt")
# time: 358.49s
# Day3.part_two("lib/day3/input.txt")