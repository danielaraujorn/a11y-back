defmodule AccessibilityReporterWeb.Inputs.PlaceInput do
  use Ecto.Schema
  import Ecto.Changeset

  alias AccessibilityReporter.FileUpload.PlaceImage
  alias AccessibilityReporterWeb.Utils.Inputs.SortInput
  alias AccessibilityReporterWeb.Utils.Types.Sort

  @required_fields [:description, :status, :latitude, :longitude, :offset, :limit]
  @optional_fields [:validator_comments, :image]
  @statuses [:inProgress, :validated, :needChanges, :invalidated]

  embedded_schema do
    field :description, :string
    field :status, Ecto.Enum, values: @statuses
    field :image, PlaceImage.Type
    field :latitude, :float
    field :longitude, :float
    field :validator_comments, :string
    field :barrier_level, :integer
    field :deficiencies, {:array, Ecto.UUID}

    # pagination
    field :offset, :integer, default: 0
    field :limit, :integer, default: 20

    # filters
    field :inserted_at, :utc_datetime_usec
    field :inserted_at_start, :utc_datetime_usec
    field :inserted_at_end, :utc_datetime_usec
    field :mine, :boolean, default: false
    field :statuses, {:array, Ecto.Enum}, values: @statuses
    field :top_right, {:array, :float}
    field :bottom_left, {:array, :float}

    # sort
    field :sort, Sort
  end

  def validate_index(attrs) do
    %__MODULE__{}
    |> cast(attrs, [
      :offset,
      :limit,
      :inserted_at,
      :inserted_at_start,
      :inserted_at_end,
      :sort,
      :mine,
      :statuses,
      :top_right,
      :bottom_left
    ])
    |> validate_number(:offset, greater_than_or_equal_to: 0)
    |> validate_number(:limit, greater_than: 0, less_than_or_equal_to: 100)
    |> SortInput.validate_sort_fields(["inserted_at"], desc: :inserted_at)
  end

  def validate_create(attrs, user) do
    %__MODULE__{}
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_validator_comments(user)
  end

  def validate_update(attrs, user) do
    fields = [:id] ++ @required_fields ++ @optional_fields

    %__MODULE__{}
    |> cast(attrs, fields)
    |> validate_validator_comments(user)
  end

  defp validate_validator_comments(%Ecto.Changeset{} = changeset, user) do
    validator_comments = changeset.changes[:validator_comments]

    if user.role == :normal and validator_comments != nil and
         String.trim(validator_comments) != "" do
      add_error(changeset, :validator_comments, "current user needs to be a validator")
    else
      changeset
    end
  end
end
