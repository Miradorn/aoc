defmodule Third.Overlap do
  alias Third.Overlap.Claim

  def run(file \\ "lib/third/input.txt") do
    file
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&build_claim/1)
  end

  def build_claim(string) do
    %{"id" => id, "x" => x, "y" => y, "width" => width, "height" => height} =
      Regex.named_captures(
        ~r/#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<width>\d+)x(?<height>\d+)/,
        string
      )

    %Claim{id: id, x: x, y: y, width: width, height: height}
  end
end

Third.Overlap.run() |> IO.inspect()
