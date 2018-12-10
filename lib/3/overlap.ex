defmodule Third.Overlap do
  import String, only: [to_integer: 1]

  alias Third.Overlap.{Fabric, Claim}

  def run(file \\ "lib/3/input.txt") do
    claims =
      file
      |> File.read!()
      |> String.split("\n")
      |> Enum.map(&build_claim/1)

    fabric_width = claims |> Enum.max_by(&(&1.x + &1.width))

    fabric_height = claims |> Enum.max_by(&(&1.y + &1.height))

    fabric =
      Fabric.new(
        width: fabric_width.x + fabric_width.width,
        height: fabric_height.y + fabric_height.height
      )

    claims
    |> Enum.reduce(fabric, &Fabric.mark_fields_from_claim(&2, &1))
    |> Map.get(:fields)
    |> List.flatten()
    |> Enum.count(&(&1 > 1))
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
end
