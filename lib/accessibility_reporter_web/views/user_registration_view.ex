defmodule AccessibilityReporterWeb.UserRegistrationView do
  use AccessibilityReporterWeb, :view

  alias AccessibilityReporterWeb.UserView

  def render("register.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json", as: :user)}
  end
end
