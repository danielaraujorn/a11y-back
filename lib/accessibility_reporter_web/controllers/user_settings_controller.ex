defmodule AccessibilityReporterWeb.UserSettingsController do
  use AccessibilityReporterWeb, :controller

  alias AccessibilityReporter.Accounts
  alias AccessibilityReporterWeb.Inputs.AccountInput
  alias AccessibilityReporterWeb.Router.Helpers, as: RouterHelpers
  alias AccessibilityReporterWeb.UserAuth

  action_fallback(AccessibilityReporterWeb.FallbackController)

  def update_email(conn, params) do
    with %{valid?: true} <- AccountInput.validate_update_email(params),
         %{"current_password" => password} <- params,
         %{current_user: current_user} <- conn.assigns,
         {:ok, applied_user} <- Accounts.apply_user_email(current_user, password, params) do
      Accounts.deliver_update_email_instructions(
        applied_user,
        current_user.email,
        fn token -> RouterHelpers.user_settings_url(conn, :confirm_email, token) end
      )

      render(conn, "update_email.json")
    end
  end

  def update_password(conn, params) do
    with %{valid?: true} <- AccountInput.validate_update_password(params),
         %{
           "current_password" => current_password,
           "new_password" => new_password,
           "new_password_confirmation" => new_password_confirmation
         } <- params,
         {:ok, user} <-
           Accounts.update_user_password(conn.assigns.current_user, current_password, %{
             "password" => new_password,
             "password_confirmation" => new_password_confirmation
           }) do
      conn
      |> UserAuth.log_in_user(user)
      |> render("update_user_password.json")
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    case Accounts.update_user_email(conn.assigns.current_user, token) do
      :ok ->
        render(conn, "email_updated.json")

      :error ->
        render(conn, "email_not_updated.json")
    end
  end
end
