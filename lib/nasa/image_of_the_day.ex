defmodule NASA.ImageOfTheDay do
  @moduledoc """
  Provides functions to retrieve and manipulate the NASA Image Of The Day.
  """

  require Logger

  @derive [Poison.Encoder]

  defstruct [
    :copyright,
    :date,
    :explanation,
    :hdurl,
    :media_type,
    :service_version,
    :title,
    :url
  ]

  @url "https://api.nasa.gov/planetary/apod?hd=true&api_key=DEMO_KEY"

  @doc """
  Retrieves the Image Of The Day and returns a struct of the information.

  ## Examples

      iex> NASA.ImageOfTheDay.get |> Map.keys
      [:__struct__, :copyright, :date, :explanation, :hdurl, :media_type,
      :service_version, :title, :url]
  """
  def get do
    Logger.debug("Fetching background image")

    @url
    |> HTTPoison.get!
    |> Map.get(:body)
    |> Poison.decode!(as: %__MODULE__{})
  end

end
