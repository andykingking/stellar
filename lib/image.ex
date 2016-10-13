defmodule Image do
  @moduledoc """
  Provides a facade for image manipulation functions.
  """

  require Logger

  defstruct [:path]

  def from_bytes(bytes, extension) do
    Logger.debug("Saving new image from bytes")

    new_path =
      %{}
      |> Map.put(:path, extension)
      |> Mogrify.temporary_path_for

    new_file = File.open!(new_path, [:write])

    IO.binwrite(new_file, bytes)
    File.close(new_file)

    %Image{path: new_path}
  end

  @doc """
  Returns the dimensions of the Image struct.

  ## Examples

      iex> %Image{path: "test/support/image_150x50.png"}
      ...> |> Image.dimensions
      {150, 50}
  """
  def dimensions(image) do
    image.path
    |> Mogrify.open
    |> Mogrify.verbose
    |> tuple_from_map([:width, :height])
  end

  @doc """
  Resizes the image, and returns a new image.

  ## Examples

      iex> %Image{path: "test/support/image_150x50.png"}
      ...> |> Image.resize({300, 100})
      ...> |> Map.get(:__struct__)
      Image
  """
  def resize(image, size) do
    Logger.debug("Resizing image")

    dimension_string =
      size
      |> Tuple.to_list
      |> Enum.join("x")

    new_image =
      image.path
      |> Mogrify.open
      |> Mogrify.resize(dimension_string)
      |> Mogrify.save
    Map.put(image, :path, new_image.path)
  end

  @doc """
  Overlays an image onto another image.
  """
  def overlay(foreground, background, gravity) do
    Logger.debug("Performing image composition")

    new_image = %Image{path: Mogrify.temporary_path_for(foreground)}
    System.cmd("composite", [
      "-gravity",
      gravity,
      foreground.path,
      background.path,
      new_image.path
    ])
    new_image
  end

  defp tuple_from_map(map, keys) do
    keys
    |> Enum.reduce([], fn(key, values) -> [Map.get(map, key) | values] end)
    |> Enum.reverse
    |> List.to_tuple
  end
end
