defmodule Second.CharDifference do
  def run(file \\ "lib/second/input.txt") do
    file
    |> File.read!()
    |> String.split()
    |> Enum.map(&String.graphemes/1)
    |> find_char_difference()
  end

  def find_char_difference(ids) do
    [[left, right]] =
      combination(2, ids)
      |> Stream.drop_while(fn [left, right] ->
        Enum.count(left -- right) > 1
      end)
      |> Enum.take(1)

    common_chars(left, right) |> Enum.join()
  end

  def combination(0, _), do: [[]]
  def combination(_, []), do: []

  def combination(n, [x | xs]) do
    for(y <- combination(n - 1, xs), do: [x | y]) ++ combination(n, xs)
  end

  def common_chars(left, right) do
    left -- left -- right
  end
end

Second.CharDifference.run() |> IO.inspect()
