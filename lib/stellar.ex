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
    ApplicationConfig.update(args)
    Logger.debug("Application started")

    @logo
    |> compose(background, ApplicationConfig.get(:location))
    |> Map.get(:path)
    |> File.copy!(ApplicationConfig.get(:output_path))

    Logger.info("Saved image to #{ApplicationConfig.get(:output_path)}")
    Logger.debug("Application complete")
  end

  defp compose(logo, bg, location) when is_nil(location) do
    Logger.debug("Using default logo location")

    Composite.compose(logo, bg)
  end
  defp compose(logo, bg, location) do
    Logger.debug("Using supplied logo location: #{location}")

    Composite.compose(logo, bg, location)
  end

  defp background do
    :background
    |> ApplicationConfig.get
    |> fetch_background
  end

  defp fetch_background(image_url) when is_nil(image_url) do
    ImageOfTheDay.get
    |> Map.get(:hdurl)
    |> fetch_background
  end
  defp fetch_background(image_url) do
    Logger.debug("Using background image URL: #{image_url}")

    extension = Path.extname(image_url)

    image_url
    |> HTTPoison.get!
    |> Map.get(:body)
    |> Image.from_bytes(extension)
  end
end
