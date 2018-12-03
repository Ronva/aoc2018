defmodule Day2 do
  import Helpers, only: [readlines: 1, async_map: 2]

  defp count_occurences(chars) do
    Enum.reduce(chars, %{}, fn(char, acc) ->
        Map.put(acc, char, (acc[char] || 0) + 1)
    end)
  end

  defp calc_checksum(ids) do
    result = async_map(ids, &(
      &1
      |> String.graphemes
      |> count_occurences
      |> Map.values
      |> Enum.uniq
    ))
    |> List.flatten
    |> count_occurences
    (result[2] || 0) * (result[3] || 0)
  end

  defp compare_ids(first_id, second_id, index \\ 0, results \\ %{matches: "", diffs: ""}) do
    if index == String.length(first_id) do
      results
    else
      is_match = String.at(first_id, index) == String.at(second_id, index)
      key = if is_match, do: :matches, else: :diffs
      new_results = Map.put(
        results,
        key,
        results[key] <> String.at(first_id, index)
      )
      compare_ids(first_id, second_id, index + 1, new_results)
    end
  end

  defp find_differences(ids, index \\ 0, result \\ nil) do
    [head | tail] = ids
    if Enum.empty?(tail) or result do
      result
    else
      new_result = async_map(tail, &(compare_ids(head, &1)))
      |> Enum.find(&(
        String.length(&1[:diffs]) == 1
      ))
      find_differences(tail, index + 1, new_result[:matches])
    end
  end

  def part_one(path) do
    readlines(path)
    |> calc_checksum
    |> to_string
    |> (&("Part 1: " <> &1)).()
    |> IO.inspect
  end

  def part_two(path, test \\ false) do
    test_string = if test, do: "(test) ", else: ""
    readlines(path)
    |> find_differences
    |> (&(test_string <> "Part 2: " <> &1)).()
    |> IO.inspect
  end
end

# Day2.part_one("lib/day2/input.txt")

# should return: fgij
Day2.part_two("lib/day2/test.txt", true)

# real input
Day2.part_two("lib/day2/input.txt")