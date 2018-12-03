defmodule Helpers do
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

  def async_map(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end
end