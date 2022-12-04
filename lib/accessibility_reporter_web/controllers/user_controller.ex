defmodule AccessibilityReporterWeb.UserController do
  use AccessibilityReporterWeb, :controller

  alias AccessibilityReporter.Accounts
  alias AccessibilityReporterWeb.Inputs.AccountInput

  action_fallback AccessibilityReporterWeb.FallbackController

  def index(conn, params) do
    with %{valid?: true} = input_changeset <- AccountInput.validate_index(params) do
      %{entries: users, total: total} = Accounts.get_users(input_changeset.changes)
      render(conn, "index.json", users: users, total: total)
    end
  end

  def show(conn, %{"id" => id}) do
    case Accounts.get_user_and_deficiencies(id) do
      nil ->
        {:error, :not_found, %{message: "User not found"}}

      user ->
        render(conn, "data_user.json", user: user)
    end
  end

  def own(conn, _params) do
    %{current_user: current_user} = conn.assigns

    case Accounts.get_user(current_user.id) do
      nil ->
        {:error, :not_found, %{message: "User not found"}}

      user ->
        render(conn, "data_user.json", user: user)
    end
  end

  def update_role(conn, params) do
    with %{valid?: true} <- AccountInput.validate_update_role(params),
         %{"id" => id, "role" => role} = params,
         {:ok, user} <- Accounts.update_user_role(id, role) do
      render(conn, "data_user.json", user: user)
    else
      nil ->
        {:error, :not_found, %{message: "User not found"}}

      otherwise ->
        otherwise
    end
  end
end
