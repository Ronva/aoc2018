defmodule Day6 do
  import Helpers, only: :functions

  def part_one(path) do
    readlines(path)
    |> IO.inspect
  end

  def part_two(path) do
    readlines(path)
    |> IO.inspect
  end
end

# should return: 17
Day6.part_one("lib/day6/test.txt")