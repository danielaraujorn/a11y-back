defmodule AccessibilityReporterWeb.UserSessionController do
  use AccessibilityReporterWeb, :controller

  alias AccessibilityReporter.Accounts
  alias AccessibilityReporterWeb.Inputs.AccountInput
  alias AccessibilityReporterWeb.UserAuth

  action_fallback AccessibilityReporterWeb.FallbackController

  def log_in(conn, params) do
    with %{valid?: true} <- AccountInput.validate_login(params),
         %{"email" => email, "password" => password} <- params,
         user when user != nil <- Accounts.get_user_by_email_and_password(email, password) do
      updated_conn = UserAuth.log_in_user(conn, user, params)
      render(updated_conn, "log_in.json", user: user)
    else
      # In order to prevent user enumeration attacks
      # don't disclose whether the email is registered.
      nil -> {:error, :unauthorized, %{message: "Invalid email or password"}}
      otherwise -> otherwise
    end
  end

  def log_out(conn, _params) do
    conn
    |> UserAuth.log_out_user()
    |> send_resp(:no_content, "")
  end
end
