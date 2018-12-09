defmodule Ninth.Game do
  def run(input \\ "412 players; last marble is worth 71646 points") do
    %{"players" => players, "last" => last} =
      Regex.named_captures(
        ~r/(?<players>\d+) players; last marble is worth (?<last>\d+) points/,
        input
      )

    run(players |> String.to_integer, last |> String.to_integer)
  end

  def run(players, last) do
    marbles = 1..last
    players = 1..players

    players
    |> Stream.cycle()
    |> Enum.take(last)
    |> Stream.zip(marbles)
    |> Enum.flat_map_reduce(
      {[0], 0, %{}},
      fn {player, marble}, {board, last_index, scores} ->
        IO.inspect(marble)
        cond do
          rem(marble, 23) == 0 ->
            index = rem(last_index - 7, length(board))

            taken = Enum.at(board, index)

            board = List.delete_at(board, index)

            scores =
              Map.update(scores, player, marble + taken, fn value -> value + marble + taken end)

            {[{player, board, index}], {board, index, scores}}

          true ->
            index = rem(last_index + 1, length(board)) + 1

            board = List.insert_at(board, index, marble)

            {[{player, board, index}], {board, index, scores}}
        end
      end
    )
    |> elem(1)
    |> elem(2)
    |> Enum.max_by(fn {_player, score} -> score end)
  end
end
