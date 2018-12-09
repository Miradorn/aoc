defmodule Fifth.Reduce do
  def run(file \\ "lib/5/input.txt") do
    input =
      file
      |> File.read!()
      |> String.graphemes()

    react(input) |> Enum.count()
  end

  def react(input) do
    IO.puts("---------------")

    {done, _, reversed_rest} =
      input
      |> Enum.zip(Enum.drop(input, 1) ++ ["0"])
      |> Enum.reduce({true, false, []}, fn {letter, next}, {done, just_deleted, head} ->
        cond do
          just_deleted ->
            {done, false, head}

          letter != next && (String.upcase(letter) == next || String.downcase(letter) == next) ->
            {false, true, head}

          true ->
            {done, false, [letter | head]}
        end
      end)

    rest = Enum.reverse(reversed_rest) |> IO.inspect()

    if done, do: rest, else: react(rest)
  end
end
