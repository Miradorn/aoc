defmodule Fourth.Shift do
  defstruct actions: %{}
end

defmodule Fourth.Guard do
  @enforce_keys ~w(id shifts)a
  defstruct id: 0, shifts: %{}
end

defmodule Fourth.MostAsleep do
  import String, only: [to_integer: 1]
  alias Forth.{Guard, Shift}

  @guards Fourth.Guards

  def run(file \\ "lib/4/input.txt") do
    Agent.start_link(&Map.new/0, name: @guards)

    claims =
      file
      |> File.read!()
      |> String.split("\n")
      |> Enum.sort()
      |> Enum.map(&parse_line/1)
      |> Enum.chunk_by(fn %{action: action} -> action =~ ~r/Guard #\d+ begins shift/ end)
      |> Enum.chunk_every(2)
      |> Enum.map(&build_shift/1)

    # |> Enum.map(&build_shift/1)
  end

  def parse_line(line) do
    %{
      "date" => date,
      "hour" => hour,
      "minute" => minute,
      "action" => action
    } =
      Regex.named_captures(
        ~r/\[(?<date>\d{4}-\d{2}-\d{2}) (?<hour>\d{2}):(?<minute>\d{2})\] (?<action>.*)/,
        line
      )

    %{date: date, hour: hour, minute: minute, action: action}
  end

  def build_shift([[start, actions]]) do
    id = Regex.named_captures(~r/Guard #(?<id>\d+) begins shift/, start)["id"]

    actions
    |> Enum.each(fn action ->
      Agent.update(@guards, fn guards ->
        Map.update(guards, id, fn
          nil ->
            %{guards | id => "TODO"}

          guard ->
            nil
        end)
      end)
    end)
  end
end
