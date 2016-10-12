defmodule Stellar do
  @moduledoc """
  Provides the interface to the application.
  """

  require Logger
  alias NASA.ImageOfTheDay

  @logo %Image{path: "assets/MYOB_logo_mono.png"}

  @doc """
  The main function for the application.
  """
  def main(args) do
    Logger.debug("Application started")

    resulting_image_path = args |> List.first

    @logo
    |> Composite.compose(background)
    |> Map.get(:path)
    |> File.copy!(resulting_image_path)

    Logger.info("Saved image to #{resulting_image_path}")
    Logger.debug("Application complete")
  end

  defp background do
    image_url =
      ImageOfTheDay.get
      |> Map.get(:hdurl)

    extension = Path.extname(image_url)

    image_url
    |> HTTPoison.get!
    |> Map.get(:body)
    |> Image.from_bytes(extension)
  end
end
