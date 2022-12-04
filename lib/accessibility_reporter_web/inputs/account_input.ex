defmodule AccessibilityReporterWeb.Inputs.AccountInput do
  use Ecto.Schema
  import Ecto.Changeset

  alias AccessibilityReporterWeb.Inputs.DeficiencyInput
  alias AccessibilityReporterWeb.Utils.Inputs.SortInput
  alias AccessibilityReporterWeb.Utils.Types.Sort

  @roles [:admin, :normal, :validator]

  embedded_schema do
    field(:email, :string)
    field(:password, :string, virtual: true, redact: true)
    field(:current_password, :string, virtual: true, redact: true)
    field(:new_password, :string, virtual: true, redact: true)
    field(:new_password_confirmation, :string, virtual: true, redact: true)
    field(:hashed_password, :string, redact: true)
    field(:confirmed_at, :naive_datetime)
    field(:role, Ecto.Enum, values: @roles)
    field(:roles, {:array, Ecto.Enum}, values: @roles)
    field(:remember_me, :boolean)
    field(:token, :binary)

    embeds_many(:deficiencies, DeficiencyInput)

    # pagination
    field(:offset, :integer, default: 0)
    field(:limit, :integer, default: 20)

    # filters
    field(:inserted_at, :utc_datetime_usec)
    field(:inserted_at_start, :utc_datetime_usec)
    field(:inserted_at_end, :utc_datetime_usec)
    field(:url, :string)
    # sort
    field(:sort, Sort)
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
      :roles,
      :email
    ])
    |> validate_number(:offset, greater_than_or_equal_to: 0)
    |> validate_number(:limit, greater_than: 0, less_than_or_equal_to: 100)
    |> SortInput.validate_sort_fields(["inserted_at"], desc: :inserted_at)
  end

  def validate_email(attrs) do
    cast_and_validate_required_fields(attrs, [:email])
  end

  def validate_reset_password(attrs) do
    attrs
    |> cast_and_validate_required_fields([:new_password, :new_password_confirmation, :token])
    |> validate_confirmation(:new_password, message: "does not match password")
    |> validate_password_format(:new_password)
  end

  def validate_update_role(attrs) do
    required_fields = [:id, :role]

    attrs
    |> cast_and_validate_required_fields(required_fields)
    |> validate_inclusion(:role, Ecto.Enum.values(__MODULE__, :role))
  end

  def validate_register_user(attrs) do
    required_fields = [:email, :password]

    attrs
    |> cast_and_validate_required_fields(required_fields)
    |> validate_email_format()
    |> validate_password_format()
    |> cast_embed(:deficiencies, with: &deficiencies_changeset/2)
  end

  def validate_forgot_password(attrs) do
    required_fields = [:email]
    optional_fields = [:url]

    %__MODULE__{}
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> validate_email_format()
  end

  def validate_login(attrs) do
    required_fields = [:email, :password]
    optional_fields = [:remember_me]

    %__MODULE__{}
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> validate_email_format()
  end

  def validate_update_email(attrs) do
    required_fields = [:email, :current_password]

    attrs
    |> cast_and_validate_required_fields(required_fields)
    |> validate_email_format()
  end

  def validate_update_password(attrs) do
    required_fields = [:current_password, :new_password, :new_password_confirmation]

    attrs
    |> cast_and_validate_required_fields(required_fields)
    |> validate_confirmation(:new_password, message: "does not match password")
    |> validate_password_format(:new_password)
  end

  defp validate_password_format(changeset, field \\ :password) do
    changeset
    |> validate_length(field, min: 8, max: 72)
    |> validate_format(field, ~r/[a-z]/, message: "at least one lower case character")
    |> validate_format(field, ~r/[A-Z]/, message: "at least one upper case character")
    |> validate_format(field, ~r/[!?@#$%^&*_0-9]/,
      message: "at least one digit or punctuation character"
    )
  end

  def validate_email_format(changeset, field \\ :email) do
    changeset
    |> validate_format(field, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(field, max: 160)
  end

  def deficiencies_changeset(changeset, params) do
    cast(changeset, params, [:name, :description])
  end

  defp cast_and_validate_required_fields(attrs, required_fields) do
    %__MODULE__{}
    |> cast(attrs, required_fields)
    |> validate_required(required_fields)
  end
end
