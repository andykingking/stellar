defmodule ApplicationConfig do
  @moduledoc """
  Handles configuration for the application.
  """

  @aliases [
    b: :background,
    l: :location,
    v: :verbose
  ]
  @options [
    background: :string,
    location: :string,
    verbose: :count
  ]

  def get(key) do
    Application.get_env(:stellar, key)
  end

  def update(args) do
    args
    |> OptionParser.parse(aliases: @aliases, strict: @options)
    |> update_configs
    |> configure_logger
  end

  defp configure_logger(args) do
    case get(:verbose) do
      1 -> Logger.configure(level: :warn)
      2 -> Logger.configure(level: :info)
      3 -> Logger.configure(level: :debug)
      _ -> Logger.configure(level: :error)
    end

    args
  end

  defp update_configs(args) do
    args
    |> elem(0)
    |> Enum.each(&update_config/1)

    args
    |> elem(1)
    |> List.insert_at(0, :output_path)
    |> List.to_tuple
    |> update_config
  end

  defp update_config({key, value}) do
    Application.put_env(:stellar, key, value)
  end
end
