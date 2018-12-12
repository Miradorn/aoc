defmodule Eleventh.Grow do
  @initial ".##..#.#..##..##..##...#####.#.....#..#..##.###.#.####......#.......#..###.#.#.##.#.#.###...##.###.#"
  @patterns %{
    ".##.#" => "#",
    "##.#." => "#",
    "##..." => "#",
    "#...." => ".",
    ".#..#" => ".",
    "#.##." => ".",
    ".##.." => ".",
    ".#.##" => ".",
    "###.." => ".",
    "..##." => "#",
    "#####" => "#",
    "#...#" => "#",
    ".#..." => "#",
    "###.#" => "#",
    "#.###" => "#",
    "##..#" => ".",
    ".###." => "#",
    "...##" => ".",
    "..#.#" => ".",
    "##.##" => "#",
    "....#" => ".",
    "#.#.#" => "#",
    "#.#.." => ".",
    ".####" => ".",
    "...#." => "#",
    "..###" => ".",
    "..#.." => "#",
    "....." => ".",
    "####." => ".",
    "#..##" => "#",
    ".#.#." => ".",
    "#..#." => "#"
    } |> Enum.into(%{}, fn {key, val} ->
    new_key = key |> String.graphemes |> Enum.map(&(&1 == "#"))
    new_val =  val == "#"

    {new_key, new_val}
  end)

  def run(initial \\ @initial) do
    initial
    |> String.graphemes
    |> Enum.map(& &1 == "#")
    |> grow_n_times(20)
  end
  
  def grow_n_times(field, rounds) do
    result = field |> _grow_n_times(rounds)

    left_index = -(rounds * 2)

    result
    |> Enum.with_index(left_index)
    |> Enum.reduce(0, fn {plant, index}, acc ->
      if plant, do: acc + index, else: acc
    end)
  end

  defp _grow_n_times(field, 0), do: field
  defp _grow_n_times(field, remaining) do
    field |> grow() |> _grow_n_times(remaining - 1)
  end

  def grow(field) do
    field = [false, false, false, false | field] ++ [false, false, false, false]

    2..(length(field) - 4)
    |> Enum.map(fn i ->
      field
      |> Enum.slice(i - 2, 5) 
    end)
    |> Enum.map(fn pattern ->
      Map.get(@patterns, pattern, false)
    end)
  end
end
