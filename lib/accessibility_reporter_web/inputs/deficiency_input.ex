defmodule AccessibilityReporterWeb.Inputs.DeficiencyInput do
  use Ecto.Schema
  import Ecto.Changeset

  alias AccessibilityReporterWeb.Utils.Inputs.SortInput
  alias AccessibilityReporterWeb.Utils.Types.Sort

  embedded_schema do
    field :name, :string
    field :description, :string
    field :place_id, :string

    embeds_many :deficiencies, DeficiencyInput

    # pagination
    field :offset, :integer, default: 0
    field :limit, :integer, default: 20

    # filters
    field :inserted_at, :utc_datetime_usec
    field :inserted_at_start, :utc_datetime_usec
    field :inserted_at_end, :utc_datetime_usec
    field :ids, {:array, Ecto.UUID}

    # sort
    field :sort, Sort
  end

  def validate_index(attrs) do
    fields = [
      :offset,
      :limit,
      :inserted_at,
      :inserted_at_start,
      :inserted_at_end,
      :sort,
      :ids,
      :name
    ]

    %__MODULE__{}
    |> cast(attrs, fields)
    |> validate_number(:offset, greater_than_or_equal_to: 0)
    |> validate_number(:limit, greater_than: 0, less_than_or_equal_to: 100)
    |> SortInput.validate_sort_fields(["inserted_at"], desc: :inserted_at)
  end

  def validate_save(attrs) do
    required_fields = [:description, :name]
    optional_fields = [:place_id]

    %__MODULE__{}
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
  end
end
