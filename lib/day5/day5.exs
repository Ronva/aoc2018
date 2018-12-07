defmodule Day5 do
  import Helpers, only: :functions

  defp is_reaction(cur, next) do
    str = cur <> next
    same_type = String.downcase(cur) == String.downcase(next)
    opposite_polarity = str =~ ~r/^[^a-z][a-z]$/u or str =~ ~r/^[a-z][^a-z]$/u
    same_type and opposite_polarity
  end

  defp process_polymer(polymer, index \\ 0) do
    if index == String.length(polymer) - 1 do
      polymer
    else
      [cur, next] = [String.at(polymer, index), String.at(polymer, index + 1)]
      if is_reaction(cur, next) do
        left = if index > 0, do: String.slice(polymer, 0..index-1), else: ""
        right = if (String.length(polymer) - index) <= 2  do
          ""
        else
          String.slice(polymer, index+2..-1)
        end
        left <> right
        |> process_polymer(if index > 0, do: index - 1, else: 0)
      else
        process_polymer(polymer, index + 1)
      end
    end
  end

  def part_one(path) do
    readlines(path)
    |> process_polymer
    |> String.length
    |> IO.inspect(printable_limit: :infinity)
  end

  def part_two(path) do
    input = readlines(path)
    input
    |> String.graphemes
    |> Stream.map(&(String.downcase(&1)))
    |> Stream.uniq
    |> Stream.map(&(
      input
      |> String.replace(&1, "")
      |> String.replace(String.upcase(&1), "")
      |> process_polymer
      |> String.length
    ))
    |> Enum.min
    |> IO.inspect
  end
end

# should return: 10
# Day5.part_one("lib/day5/test.txt")

# should return: 4
# Day5.part_two("lib/day5/test.txt")

# real input
# Day5.part_one("lib/day5/input.txt")
Day5.part_two("lib/day5/input.txt")