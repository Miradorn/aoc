defmodule Third.Overlap.Fabric do
  alias __MODULE__
  alias Third.Overlap.Claim

  @enforce_keys ~w(fields)a
  defstruct fields: nil

  def new(width: width, height: height) do
    fields = 0 |> List.duplicate(width) |> List.duplicate(height)
    %Fabric{fields: fields}
  end

  def mark_fields_from_claim(%Fabric{fields: fields} = fabric, %Claim{
        x: cx,
        y: cy,
        width: width,
        height: height
      }) do
    fields =
      cx..(cx + width - 1)
      |> Enum.reduce(fields, fn x, fields ->
        List.update_at(fields, x, fn row ->
          Enum.reduce(cy..(cy + height - 1), row, fn y, row ->
            List.update_at(row, y, &(&1 + 1))
          end)
        end)
      end)

    %{fabric | fields: fields}
  end
end
