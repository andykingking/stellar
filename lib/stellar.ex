defmodule Stellar do
  @moduledoc """
  Provides the interface to the application.
  """

  require Logger
  alias NASA.ImageOfTheDay

  @logo %Image{path: "assets/MYOB_logo_mono.png"}
  @aliases [
    b: :background
  ]
  @options [
    background: :string
  ]

  @doc """
  The main function for the application.
  """
  def main(args) do
    Logger.debug("Application started")
    parsed_args = OptionParser.parse(args, aliases: @aliases, strict: @options)

    resulting_image_path = elem(parsed_args, 1) |> List.first

    background =
      parsed_args
      |> elem(0)
      |> Keyword.get(:background)
      |> fetch_background

    @logo
    |> Composite.compose(background)
    |> Map.get(:path)
    |> File.copy!(resulting_image_path)

    Logger.info("Saved image to #{resulting_image_path}")
    Logger.debug("Application complete")
  end

  defp fetch_background(image_url) when is_nil(image_url) do
    ImageOfTheDay.get
    |> Map.get(:hdurl)
    |> fetch_background
  end
  defp fetch_background(image_url) do
    extension = Path.extname(image_url)

    image_url
    |> HTTPoison.get!
    |> Map.get(:body)
    |> Image.from_bytes(extension)
  end
end
