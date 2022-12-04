defmodule AccessibilityReporterWeb.UserConfirmationView do
  use AccessibilityReporterWeb, :view

  def render("confirm_email.json", _params) do
    %{
      data: %{
        messages: [
          "User confirmed successfully."
        ]
      }
    }
  end

  def render("create_email_confirmation.json", _params) do
    %{
      data: %{
        messages: [
          "If your email is in our system and it has not been confirmed yet, " <>
            "you will receive an email with instructions shortly."
        ]
      }
    }
  end
end
