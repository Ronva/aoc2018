defmodule Day4 do
  import Helpers, only: :functions

  defp get_value(line, target) do
    reg = cond do
      target == :id -> ~r/#(\d+)/
      target == :minutes -> ~r/:(\d+)/
      true -> nil
    end
    Regex.run(reg, line)
    |> Enum.at(1)
    |> String.to_integer
  end

  defp calculate_sleep(times) do
    times
    |> Enum.chunk_every(2, 2, :discard)
    |> Enum.reduce(0, fn(vals, acc) ->
      acc + Enum.at(vals, 1) - Enum.at(vals, 0)
    end)
  end

  defp find_minute(times) do
    times
    |> Enum.chunk_every(2, 2, :discard)
    |> Enum.reduce([], fn(vals, acc) ->
      [a, b] = vals
      acc ++ Enum.to_list(a..b-1)
    end)
  end

  defp format_schedule(schedule, line_num \\ 0, cur_id \\ nil, formatted \\ %{}) do
    if line_num == Enum.count(schedule) do
      formatted
    else
      line = Enum.at(schedule, line_num)
      cond do
        line =~ "#" ->
          id = get_value(line, :id)
          format_schedule(
            schedule,
            line_num + 1,
            id,
            Map.update(formatted, id, [], &(&1))
          )
        (line =~ "falls" || line =~ "wakes") && cur_id ->
          minutes = get_value(line, :minutes)
          format_schedule(
            schedule,
            line_num + 1,
            cur_id,
            Map.put(formatted, cur_id, formatted[cur_id] ++ [minutes])
          )
        true -> format_schedule(schedule, line_num + 1, cur_id, formatted)
      end
    end
  end

  defp get_schedule(path) do
    path
    |> readlines
    |> Enum.sort
    |> format_schedule
  end

  def part_one(path) do
    [id, _, times] = get_schedule(path)
    |> Enum.reduce(%{id: nil, sleep: 0}, fn({key, val}, acc) ->
      sleep = calculate_sleep(val)
      cond do
        sleep > acc[:sleep] -> %{id: key, sleep: sleep, times: val}
        true -> acc
      end
    end)
    |> Map.values
    [minute | _] = find_minute(times)
    |> mode
    IO.inspect(id * minute, label: "Result")
  end

  def part_two(path) do
    [id, minute, _] = get_schedule(path)
    |> Enum.reject(fn({_, times}) ->
      Enum.empty?(times)
    end)
    |> async_map(fn({id, times}) ->
      minutes = find_minute(times)
      [minute | _] = mode(minutes)
      count = Enum.count(minutes, &(&1 == minute))
      [id, minute, count]
    end)
    |> Enum.reduce(fn([id, minute, count], acc) ->
      [_, _, highest_count] = acc
      if count > highest_count, do: [id, minute, count], else: acc
    end)

    IO.inspect(id * minute)
  end
end

# should return: 240
# Day4.part_one("lib/day4/test.txt")

# should return: 4455
# Day4.part_two("lib/day4/test.txt")

# real input
# Day4.part_one("lib/day4/input.txt")
Day4.part_two("lib/day4/input.txt")