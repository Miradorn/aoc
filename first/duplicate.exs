defmodule First.Duplicate do
  def run(file \\ "first/input.txt") do
    file
    |> File.read!()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> find_duplicate()
  end

  def find_duplicate(list) do
    list
    |> Stream.cycle()
    |> Enum.reduce_while({0, MapSet.new()}, fn elem, {freq, seen} ->
      new_freq = freq + elem

      if MapSet.member?(seen, new_freq) do
        {:halt, new_freq}
      else
        {:cont, {new_freq, MapSet.put(seen, new_freq)}}
      end
    end)
  end
end

First.Duplicate.run() |> IO.inspect()
