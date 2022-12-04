defmodule AccessibilityReporterWeb.PlaceView do
  use AccessibilityReporterWeb, :view

  alias AccessibilityReporterWeb.DeficiencyView
  alias AccessibilityReporterWeb.PlaceView

  def render("places.json", %{places: places, total: total}) do
    %{data: %{places: render_many(places, PlaceView, "place.json", as: :place)}, total: total}
  end

  def render("data_place.json", %{place: place}) do
    %{data: render_one(place, PlaceView, "place.json", as: :place)}
  end

  def render("place.json", %{place: place}) do
    palce_with_required_fields = %{
      id: place.id,
      description: place.description,
      status: place.status,
      image: place.image,
      latitude: elem(place.location.coordinates, 0),
      longitude: elem(place.location.coordinates, 1),
      validator_comments: place.validator_comments,
      inserted_at: place.inserted_at,
      updated_at: place.updated_at,
      barrier_level: place.barrier_level,
      user_id: place.user_id
    }

    if Ecto.assoc_loaded?(place.deficiencies) do
      Map.put(
        palce_with_required_fields,
        :deficiencies,
        render_many(place.deficiencies, DeficiencyView, "deficiency.json", as: :deficiency)
      )
    else
      palce_with_required_fields
    end
  end
end
