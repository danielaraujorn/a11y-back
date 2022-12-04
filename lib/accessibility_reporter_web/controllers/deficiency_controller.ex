defmodule AccessibilityReporterWeb.DeficiencyController do
  use AccessibilityReporterWeb, :controller

  alias AccessibilityReporter.Deficiencies
  alias AccessibilityReporterWeb.Inputs.DeficiencyInput

  action_fallback AccessibilityReporterWeb.FallbackController

  def index(conn, params) do
    with %{valid?: true} = input_changeset <- DeficiencyInput.validate_index(params) do
      %{entries: deficiencies, total: total} = Deficiencies.all(input_changeset.changes)

      render(conn, "deficiencies.json", deficiencies: deficiencies, total: total)
    end
  end

  def show(conn, %{"id" => id}) do
    case Deficiencies.one(%{id: id}) do
      nil ->
        deficiency_not_found()

      deficiency ->
        render(conn, "data_deficiency.json", deficiency: deficiency)
    end
  end

  def create(conn, params) do
    with %{valid?: true} <- DeficiencyInput.validate_save(params),
         %{current_user: current_user} <- conn.assigns,
         {:ok, deficiency} <-
           params |> Map.put("user_id", current_user.id) |> Deficiencies.insert() do
      conn
      |> put_status(:created)
      |> render("data_deficiency.json", deficiency: deficiency)
    end
  end

  def update(conn, params) do
    with %{valid?: true} <- DeficiencyInput.validate_save(params),
         {:ok, deficiency} <- Deficiencies.update(params) do
      render(conn, "data_deficiency.json", deficiency: deficiency)
    else
      {:error, :not_found} ->
        deficiency_not_found()

      otherwise ->
        otherwise
    end
  end

  def delete(conn, %{"id" => id}) do
    %{current_user: current_user} = conn.assigns

    case Deficiencies.delete(id, current_user.id) do
      :ok -> send_resp(conn, :ok, "")
      :not_found -> deficiency_not_found()
    end
  end

  defp deficiency_not_found, do: {:error, :not_found, %{message: "Deficiency not found"}}
end
