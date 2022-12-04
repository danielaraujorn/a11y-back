defmodule AccessibilityReporterWeb.UserConfirmationController do
  use AccessibilityReporterWeb, :controller

  alias AccessibilityReporter.Accounts

  alias AccessibilityReporterWeb.Inputs.AccountInput
  alias AccessibilityReporterWeb.Router.Helpers, as: RouterHelpers

  action_fallback AccessibilityReporterWeb.FallbackController

  def create(conn, params) do
    with %{valid?: true} <- AccountInput.validate_email(params),
         %{"email" => email} <- params do
      if user = Accounts.get_user_by_email(email) do
        Accounts.deliver_user_confirmation_instructions(
          user,
          fn token -> RouterHelpers.user_confirmation_url(conn, :update, token) end
        )
      end

      # In order to prevent user enumeration attacks, regardless of the outcome
      # show an impartial success/error message.
      render(conn, "create_email_confirmation.json")
    end
  end

  # Do not log in the user after confirmation to avoid a
  # leaked token giving the user access to the account.
  def update(conn, %{"token" => token}) do
    case Accounts.confirm_user(token) do
      {:ok, _} ->
        render(conn, "confirm_email.json")

      :error ->
        {:error, :unprocessable_entity,
         %{message: "Invalid confirmation link is invalid or it has expired."}}
    end
  end
end
