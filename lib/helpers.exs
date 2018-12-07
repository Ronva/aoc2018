defmodule Helpers do
  @moduledoc """
  Helper functions.
  """

  def readlines(path) do
    lines = File.stream!(path) |> Enum.map(&String.trim/1)
    case Enum.count(lines) do
      1 -> Enum.at(lines, 0)
      _ -> lines
    end
  end

  def printlines(enum) do
    Enum.each(enum, &(IO.inspect(&1)))
  end

  def async_map(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end

  def mode(list) do
    gb = Enum.group_by(list, &(&1))
    max = Enum.map(gb, fn({_, val}) -> length(val) end)
    |> Enum.max
    for {key, val} <- gb, length(val) == max, do: key
  end
end