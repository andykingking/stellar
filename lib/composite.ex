defmodule Composite do
  @moduledoc """
  Provides the functions that when combined compose the logo with the
  background image.
  """

  @doc """
  Performs the compose use case.
  """
  def compose(logo, background, overlay_gravity \\ "SouthWest") do
    logo
    |> shrink_to_fit(background)
    |> Image.overlay(background, overlay_gravity)
  end

  defp shrink_to_fit(logo, background) do
    new_size =
      background
      |> Image.dimensions
      |> Tuple.to_list
      |> Enum.map(fn(element) -> element / 3 end)
      |> List.to_tuple

    logo
    |> Image.resize(new_size)
  end

end
