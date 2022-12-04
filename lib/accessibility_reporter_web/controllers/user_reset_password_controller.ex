defmodule AccessibilityReporterWeb.UserResetPasswordController do
  use AccessibilityReporterWeb, :controller

  alias AccessibilityReporter.Accounts
  alias AccessibilityReporterWeb.Helpers
  alias AccessibilityReporterWeb.Inputs.AccountInput
  alias AccessibilityReporterWeb.Router.Helpers, as: RouterHelpers

  plug :get_user_by_reset_password_token when action in [:reset_password]

  action_fallback AccessibilityReporterWeb.FallbackController

  def forgot_password(conn, params) do
    with %{valid?: true} <- AccountInput.validate_forgot_password(params) do
      %{"email" => email} = params
      url = params["url"]

      if user = Accounts.get_user_by_email(email) do
        Accounts.deliver_user_reset_password_instructions(
          user,
          fn token ->
            if url != nil,
              do: "#{url}?token=#{token}",
              else: RouterHelpers.user_reset_password_url(conn, :reset_password, token)
          end
        )
      end

      render(conn, "forgot_password.json")
    end
  end

  # Do not log in the user after reset password to avoid a
  # leaked token giving the user access to the account.
  def reset_password(conn, params) do
    with %{valid?: true} = user <- AccountInput.validate_reset_password(params),
         {:ok, _} <-
           Accounts.reset_user_password(conn.assigns.user, %{
             password: user.changes.new_password,
             password_confirmation: user.changes.new_password_confirmation
           }) do
      render(conn, "reset_password.json")
    end
  end

  defp get_user_by_reset_password_token(conn, _opts) do
    with %{"token" => token} <- conn.params,
         user when user != nil <- Accounts.get_user_by_reset_password_token(token) do
      conn |> assign(:user, user) |> assign(:token, token)
    else
      _ ->
        Helpers.create_error_view(conn, :unauthorized, %{message: "User not authorized"})
    end
  end
end
