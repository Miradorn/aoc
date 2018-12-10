defmodule Fifth.Optimize do
  def run(file \\ "lib/5/input.txt") do
    input =
      file
      |> File.read!()

    ?a..?z
    |> Enum.to_list()
    |> List.to_string()
    |> String.graphemes()
    |> Enum.into(%{}, fn c ->
      rest =
        input
        |> String.replace(c, "")
        |> String.replace(String.upcase(c), "")
        |> String.graphemes()
        |> react()
        |> Enum.count()

      {c, rest}
    end)
    |> Enum.min_by(fn {c, rest} -> rest end)
  end

  def react(input) do
    # IO.puts("---------------")

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

    rest = Enum.reverse(reversed_rest)

    if done, do: rest, else: react(rest)
  end
end
