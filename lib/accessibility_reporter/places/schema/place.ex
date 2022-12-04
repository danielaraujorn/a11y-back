defmodule AccessibilityReporter.Places.Schema.Place do
  use AccessibilityReporter.Schema
  import Ecto.Changeset

  alias AccessibilityReporter.Accounts.Schema.User
  alias AccessibilityReporter.FileUpload.PlaceImage
  alias AccessibilityReporter.Deficiencies.Schema.Deficiency

  @required_fields [:description, :status, :location]
  @optional_fields [:image, :validator_comments, :barrier_level]
  @assoc_fields [:user_id]

  schema "places" do
    field :description, :string
    field :status, Ecto.Enum, values: [:inProgress, :validated, :needChanges]
    field :image, PlaceImage.Type
    field :location, Geo.PostGIS.Geometry
    field :validator_comments, :string
    field :barrier_level, :integer

    belongs_to :user, User, foreign_key: :user_id, type: :binary_id

    has_many :deficiencies, Deficiency

    timestamps()
  end

  def insert_changeset(place, attrs \\ %{}) do
    place
    |> cast(attrs, @required_fields ++ @optional_fields ++ @assoc_fields)
    |> validate_required(@required_fields ++ @assoc_fields)
  end

  def update_changeset(place, attrs \\ %{}) do
    place
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
