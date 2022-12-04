defmodule AccessibilityReporterWeb.UserSettingsView do
  use AccessibilityReporterWeb, :view

  def render("update_email.json", _params) do
    %{
      data: %{messages: ["A link to confirm your email change has been sent to the new address"]}
    }
  end

  def render("update_user_password.json", _params) do
    %{
      data: %{messages: ["Password updated successfully"]}
    }
  end

  def render("email_updated.json", _params) do
    %{
      data: %{messages: ["Email changed successfully"]}
    }
  end

  def render("email_not_updated.json", _params) do
    %{
      data: %{
        messages: ["Email change link is invalid or it has expired"]
      }
    }
  end
end
