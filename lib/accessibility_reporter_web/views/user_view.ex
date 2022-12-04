defmodule AccessibilityReporterWeb.UserView do
  use AccessibilityReporterWeb, :view

  alias AccessibilityReporterWeb.DeficiencyView
  alias AccessibilityReporterWeb.UserView

  def render("index.json", %{users: users, total: total}) do
    %{data: %{users: render_many(users, UserView, "user.json", as: :user)}, total: total}
  end

  def render("data_user.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json", as: :user)}
  end

  def render("user.json", %{user: user}) do
    user_with_required_fields = Map.take(user, [:id, :email, :role, :inserted_at, :updated_at])

    if Ecto.assoc_loaded?(user.deficiencies) do
      Map.put(
        user_with_required_fields,
        :deficiencies,
        render_many(user.deficiencies, DeficiencyView, "deficiency.json", as: :deficiency)
      )
    else
      user_with_required_fields
    end
  end
end
