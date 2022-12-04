defmodule AccessibilityReporterWeb.UserResetPasswordView do
  use AccessibilityReporterWeb, :view

  def render("forgot_password.json", _params) do
    %{
      data: %{messages: ["If the account exists, we've sent an email"]}
    }
  end

  def render("reset_password.json", _params) do
    %{
      data: %{messages: ["Successfully reset password"]}
    }
  end
end
