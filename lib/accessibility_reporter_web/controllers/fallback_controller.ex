defmodule AccessibilityReporterWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.
  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use AccessibilityReporterWeb, :controller

  alias AccessibilityReporterWeb.Helpers

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(AccessibilityReporterWeb.ChangesetView)
    |> render("validation_errors.json", changeset: changeset)
  end

  def call(conn, %Ecto.Changeset{valid?: false} = changeset) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(AccessibilityReporterWeb.ChangesetView)
    |> render("validation_errors.json", changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.

  # This clause handles authentication errors.
  def call(conn, {:error, status, errors}) do
    Helpers.create_error_view(conn, status, errors)
  end
end
