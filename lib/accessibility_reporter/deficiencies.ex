defmodule AccessibilityReporter.Deficiencies do
  @moduledoc """
  The Deficiencies context.
  """

  import Ecto.Query, warn: false

  alias AccessibilityReporter.Deficiencies.Schema.Deficiency
  alias AccessibilityReporter.Repo
  alias AccessibilityReporter.Utils.DataManipulation

  @doc """
  Get all user's deficiencies.
  """
  @spec all(map) :: %{entries: any, total: integer}
  def all(params) do
    deficiency_fields = Deficiency.__schema__(:fields)

    %{
      entries:
        Deficiency
        |> select([d], map(d, ^deficiency_fields))
        |> preload([u], user: u)
        |> DataManipulation.apply_operations(params)
        |> Repo.all(),
      total: Deficiency |> select([d], count(d.id)) |> Repo.one()
    }
  end

  def one(%{id: id}) do
    deficiency_fields = Deficiency.__schema__(:fields)

    Deficiency
    |> select([d], map(d, ^deficiency_fields))
    |> where([d], d.id == ^id)
    |> Repo.one()
  end

  def insert(attrs) do
    %Deficiency{} |> Deficiency.save_changeset(attrs) |> Repo.insert()
  end

  def update(attrs) do
    case Repo.get(Deficiency, attrs["id"]) do
      nil ->
        {:error, :not_found}

      deficiency ->
        deficiency
        |> Deficiency.save_changeset(attrs)
        |> Repo.update()
    end
  end

  @doc """
  Hard delete a deficiency.
  """
  def delete(id, user_id) do
    delete_operation =
      Deficiency
      |> where([d], d.user_id == ^user_id and d.id == ^id)
      |> Repo.delete_all()

    case delete_operation do
      {1, nil} -> :ok
      {0, nil} -> :not_found
    end
  end
end
