defmodule AccessibilityReporterWeb.PlaceController do
  use AccessibilityReporterWeb, :controller

  alias AccessibilityReporter.Places
  alias AccessibilityReporterWeb.Inputs.PlaceInput
  alias Geo.Point

  action_fallback(AccessibilityReporterWeb.FallbackController)

  def index(conn, params) do
    with %{valid?: true} = input_changeset <- PlaceInput.validate_index(params) do
      %{entries: places, total: total} =
        case conn.assigns.current_user do
          nil ->
            Places.public_all(input_changeset.changes)

          current_user ->
            Places.all(input_changeset.changes, current_user)
        end

      render(conn, "places.json", places: places, total: total)
    end
  end

  def show(conn, %{"id" => id}) do
    place =
      if is_nil(conn.assigns.current_user) do
        Places.public_get(id)
      else
        Places.get(id, conn.assigns.current_user)
      end

    case place do
      nil ->
        place_not_found()

      place ->
        render(conn, "data_place.json", place: place)
    end
  end

  def create(conn, params) do
    with %{current_user: current_user} <- conn.assigns,
         %{valid?: true} <- PlaceInput.validate_create(params, current_user),
         {:ok, place} <-
           params
           |> add_location()
           |> Map.put("user_id", current_user.id)
           |> Places.insert() do
      conn
      |> put_status(:created)
      |> render("data_place.json", place: place)
    end
  end

  def update(conn, params) do
    with %{current_user: current_user} <- conn.assigns,
         %{valid?: true} <- PlaceInput.validate_update(params, current_user),
         {:ok, place} <-
           params
           |> add_location()
           |> Places.update(current_user) do
      render(conn, "data_place.json", place: place)
    else
      {:error, :not_found} ->
        place_not_found()

      otherwise ->
        otherwise
    end
  end

  def delete(conn, %{"id" => id}) do
    %{current_user: current_user} = conn.assigns

    case Places.delete(id, current_user) do
      :ok -> send_resp(conn, :no_content, "")
      :not_found -> place_not_found()
    end
  end

  defp add_location(%{"longitude" => longitude, "latitude" => latitude} = params) do
    Map.put(
      params,
      "location",
      %Point{
        coordinates: {to_float!(latitude), to_float!(longitude)},
        srid: 4326
      }
    )
  end

  defp add_location(params), do: params

  defp to_float!(value) when is_number(value), do: value

  defp to_float!(value) do
    {float_value, _} = Float.parse(to_string(value))
    float_value
  end

  defp place_not_found, do: {:error, :not_found, %{message: "Place not found"}}
end
