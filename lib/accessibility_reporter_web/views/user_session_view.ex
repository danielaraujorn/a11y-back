defmodule AccessibilityReporterWeb.UserSessionView do
  use AccessibilityReporterWeb, :view

  alias AccessibilityReporterWeb.UserView

  def render("log_in.json", %{user: user}) do
    %{
      data: render_one(user, UserView, "user.json", as: :user)
    }
  end

  def render("log_out.json", _params) do
    %{
      data: %{messages: ["Logged out successfully"]}
    }
  end
end
