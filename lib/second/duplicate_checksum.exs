defmodule Second.DuplicateChecksum do
  def run(file \\ "lib/second/input.txt") do
    file
    |> File.read!()
    |> String.split()
    |> calc_checksum()
  end

  def calc_checksum(ids) do
    {twos, threes} =
      ids
      |> Enum.map(&categorize/1)
      |> Enum.reduce({0, 0}, fn
        :two, {twos, threes} -> {twos + 1, threes}
        :three, {twos, threes} -> {twos, threes + 1}
        :both, {twos, threes} -> {twos + 1, threes + 1}
        :none, acc -> acc
      end)

    twos * threes
  end

  def categorize(id) do
    id
    |> letter_counts()
    |> map_letter_counts()
  end

  def letter_counts(string) do
    string
    |> String.graphemes()
    |> Enum.group_by(& &1)
    |> Enum.map(fn {_letter, list} -> Enum.count(list) end)
    |> Enum.uniq()
  end

  def map_letter_counts(list) do
    cond do
      Enum.member?(list, 2) && Enum.member?(list, 3) -> :both
      Enum.member?(list, 2) -> :two
      Enum.member?(list, 3) -> :three
      true -> :none
    end
  end
end

Second.DuplicateChecksum.run() |> IO.inspect()
