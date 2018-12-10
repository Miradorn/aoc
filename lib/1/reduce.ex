defmodule First.Reduce do
  def run(file \\ "lib/1/input.txt") do
    file
    |> File.read!()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(&+/2)
  end
end
