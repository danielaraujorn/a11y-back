defmodule AccessibilityReporterWeb.UserRegistrationController do
  use AccessibilityReporterWeb, :controller

  alias AccessibilityReporter.Accounts
  alias AccessibilityReporterWeb.Inputs.AccountInput
  alias AccessibilityReporterWeb.Router.Helpers, as: RouterHelpers

  action_fallback AccessibilityReporterWeb.FallbackController

  def create(conn, params) do
    with %{valid?: true} <- AccountInput.validate_register_user(params),
         {:ok, user_schema} <- Accounts.register_user(params) do
      user = Accounts.get_user_and_deficiencies(user_schema.id)

      Accounts.deliver_user_confirmation_instructions(
        user,
        fn token -> RouterHelpers.user_confirmation_url(conn, :update, token) end
      )

      conn
      |> put_status(:created)
      |> render("register.json", user: user)
    end
  end
end
