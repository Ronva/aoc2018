defmodule AOC do
  @moduledoc """
  Helper functions.
  """

  def readlines(path) do
    File.stream!(path)
    |> Enum.map(&String.trim/1)
  end

  def printlines(enum) do
    Enum.each(enum, fn(x) -> IO.puts x end)
  end
end

import AOC
readlines("lib/test.txt")
|> printlines