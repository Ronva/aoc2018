defmodule Day1 do
  def frequency(freqs, find_repeat \\ false, cur \\ 0, acc \\ [0]) do
    latest = Enum.at(acc, 0)
    if cur == Enum.count(freqs) do
      if find_repeat, do: frequency(freqs, find_repeat, 0, acc), else: latest
    else
      new_acc = latest + String.to_integer(Enum.at(freqs, cur))
      if find_repeat and Enum.member?(acc, new_acc) do
        new_acc
      else
        frequency(freqs, find_repeat, cur + 1, [new_acc | acc])
      end
    end
  end

  def run(path, find_repeat \\ false) do
    import Helpers, only: [readlines: 1]
    readlines(path)
    |> frequency(find_repeat)
  end
end

# should return: [0, 10, 5, 14]
IO.inspect([
  Day1.run("lib/day1/test.txt", true),
  Day1.run("lib/day1/test2.txt", true),
  Day1.run("lib/day1/test3.txt", true),
  Day1.run("lib/day1/test4.txt", true)
])

# Real input
# IO.inspect(Day1.run("lib/day1/input.txt", true))