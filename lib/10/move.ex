defmodule Tenth.Move do
  import String, only: [to_integer: 1, trim: 1]

  @type point :: %{pos: %{x: integer, y: integer}, vel: %{x: integer, y: integer}}

  def run(file \\ 'lib/10/input.txt') do
    points =
      file
      |> File.read!()
      |> String.split("\n")
      |> Stream.map(&make_point/1)
      |> Enum.to_list

    move(points, 0)
  end

  def move(points, step) do
    {next_points, output} =
      points
      |> Enum.reduce({[], %{}}, fn point, {new_points, output} ->
        output =
          Map.update(output, point.pos.x, %{point.pos.y => true}, fn row -> Map.put(row, point.pos.y, true) end)

        {
          [
            %{point |
              pos: %{
                x: point.pos.x + point.vel.x,
                y: point.pos.y + point.vel.y
              }
            }
            | new_points],
          output
        }
      end)

    field_x_min = points |> Enum.min_by(&(&1.pos.x)) |> get_in([:pos, :x])
    field_x_max = points |> Enum.max_by(&(&1.pos.x)) |> get_in([:pos, :x])

    field_y_min = points |> Enum.min_by(&(&1.pos.y)) |> get_in([:pos, :y])
    field_y_max = points |> Enum.max_by(&(&1.pos.y)) |> get_in([:pos, :y])

    if field_y_max - field_y_min < 15 do
      for y <- field_y_min..field_y_max do
        row = Enum.map(field_x_min..field_x_max, fn x -> if output[x][y], do: "X", else: "." end)
      IO.puts(step)
        IO.puts(row)
      end
    end

    move(next_points, step + 1)
  end

  def make_point(text) do
    %{
      "pos_x" => pos_x,
      "pos_y" => pos_y,
      "vel_x" => vel_x,
      "vel_y" => vel_y
    } = Regex.named_captures(~r/position=<(?<pos_x>(-| )?-?\d+), (?<pos_y>(-| )?\d+)> velocity=<(?<vel_x>(-| )?\d+), (?<vel_y>(-| )?\d+)>/, text)

    %{pos: %{x: t(pos_x), y: t(pos_y)}, vel: %{x: t(vel_x), y: t(vel_y)}}
  end

  defp t(s) do
    s |> trim |> to_integer
  end
end
