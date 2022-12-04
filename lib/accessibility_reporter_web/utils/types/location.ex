defmodule AccessibilityReporterWeb.Utils.Types.Location do
  @moduledoc """
  An `Ecto.Type` that casts from a JSON string array and validates it.
  """

  use Ecto.Type

  @impl true
  def type, do: :sort

  @impl true
  def cast(sort) when is_binary(sort) do
    with {:ok, [lng, lat]} when is_number(lng) and is_number(lat) <- Jason.decode(sort) do
      {:ok, [lng, lat]}
    else
      _ -> :error
    end
  end

  def cast(_), do: :error

  @impl true
  def load(data), do: data

  @impl true
  def dump([field, order] = s) when is_binary(field) and is_binary(order), do: {:ok, s}
  def dump(_), do: :error
end
