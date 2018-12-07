defmodule Day6 do
  import Helpers, only: :functions

  defp get_steps(line) do
    [String.at(line, 5), String.at(line, 36)]
  end

  defp order_steps(list) do
    steps = async_map(list, &(get_steps(&1)))
  end

  def part_one(path) do
    readlines(path)
    |> order_steps
    |> IO.inspect
  end

  def part_two(path) do
    readlines(path)
    |> IO.inspect
  end
end

# should return: 17
Day6.part_one("lib/day7/test.txt")