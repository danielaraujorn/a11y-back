defmodule AccessibilityReporterWeb.ChangesetView do
  use AccessibilityReporterWeb, :view

  @doc """
  Traverses and translates changeset errors.
  See `Ecto.Changeset.traverse_errors/2` and
  `TuiterWeb.ErrorHelpers.translate_error/1` for more details.
  """
  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn error ->
      translate_error(error)
    end)
  end

  def render("validation_errors.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{message: "Invalid params", details: translate_errors(changeset)}
  end
end
