defmodule Third.NoOverlap do
  import String, only: [to_integer: 1]

  alias Third.Overlap.Claim

  def run(file \\ "lib/third/input.txt") do
    claims =
      file
      |> File.read!()
      |> String.split("\n")
      |> Enum.map(&build_claim/1)

    claims
    |> Enum.find(fn claim ->
      claims |> Enum.all?(&no_overlap?(&1, claim))
    end)
    |> Map.get(:id)
  end

  def build_claim(string) do
    %{"id" => id, "x" => x, "y" => y, "width" => width, "height" => height} =
      Regex.named_captures(
        ~r/#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<width>\d+)x(?<height>\d+)/,
        string
      )

    %Claim{
      id: to_integer(id),
      x: to_integer(x),
      y: to_integer(y),
      width: to_integer(width),
      height: to_integer(height)
    }
  end

  def no_overlap?(claim, claim), do: true

  def no_overlap?(l, r) do
    l.x + l.width < r.x || l.x > r.x + r.width || l.y + l.height < r.y || l.y > r.y + r.height
  end
end

Third.NoOverlap.run() |> IO.inspect()
