defmodule First.Reduce do
  def run(file \\ "first/input.txt") do
    file
    |> File.read!()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(&+/2)
  end
end

First.Reduce.run() |> IO.inspect()
