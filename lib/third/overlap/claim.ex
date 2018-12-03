defmodule Third.Overlap.Claim do
  @enforce_keys ~w(id x y width height)a
  defstruct id: 0, x: 0, y: 0, width: 0, height: 0
end
