defmodule AccessibilityReporter.Deficiencies.Schema.Deficiency do
  use AccessibilityReporter.Schema
  import Ecto.Changeset

  alias AccessibilityReporter.Accounts.Schema.User
  alias AccessibilityReporter.Places.Schema.Place

  schema "deficiencies" do
    field :name, :string
    field :description, :string
    belongs_to :user, User, foreign_key: :user_id, type: :binary_id
    belongs_to :place, Place, foreign_key: :place_id, type: :binary_id

    timestamps()
  end

  def save_changeset(deficiency, attrs \\ %{}) do
    required_fields = [:description, :name]
    optional_fields = [:user_id, :place_id]

    deficiency
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
  end

  def update_changeset(deficiency, attrs \\ %{}) do
    required_fields = [:id, :description, :name, :place_id]

    deficiency
    |> cast(attrs, required_fields)
    |> validate_required([:id])
  end
end
