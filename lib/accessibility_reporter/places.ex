defmodule AccessibilityReporter.Places do
  @moduledoc """
  The Places context.
  """

  import Ecto.Query, warn: false

  alias AccessibilityReporter.FileUpload.PlaceImage
  alias AccessibilityReporter.Places.Schema.Place
  alias AccessibilityReporter.Repo
  alias AccessibilityReporter.Utils.DataManipulation
  alias AccessibilityReporter.Deficiencies.Schema.Deficiency

  @doc """
  Get all places with all fields by user permission.
  """
  @spec all(map, struct) :: %{entries: any, total: integer}
  def all(params, user) do
    place_fields = Place.__schema__(:fields)
    deficiencies_fields = [deficiencies: [:id, :name, :description, :place_id]]
    select_fields = place_fields ++ deficiencies_fields

    query =
      Place
      |> get_by_user_role_or_status(user, params)
      |> get_by_statuses(params)
      |> get_by_location(params)

    %{
      entries:
        query
        |> join(:left, [p], d in Deficiency, on: d.place_id == p.id)
        |> preload([p, d], deficiencies: d)
        |> select([p], map(p, ^select_fields))
        |> DataManipulation.apply_operations(params)
        |> Repo.all(),
      total: query |> select([d], count(d.id)) |> Repo.one()
    }
  end

  @spec public_all(map) :: %{entries: any, total: integer}
  def public_all(params) do
    place_fields = Place.__schema__(:fields)
    deficiencies_fields = [deficiencies: [:id, :name, :description, :place_id]]
    select_fields = place_fields ++ deficiencies_fields

    query =
      Place
      |> where(status: :validated)
      |> get_by_statuses(params)
      |> get_by_location(params)

    %{
      entries:
        query
        |> join(:left, [p], d in Deficiency, on: d.place_id == p.id)
        |> preload([p, d], deficiencies: d)
        |> select([p], map(p, ^select_fields))
        |> DataManipulation.apply_operations(params)
        |> Repo.all(),
      total: query |> select([d], count(d.id)) |> Repo.one()
    }
  end

  @doc """
  Get a place by user permission
  """
  def get(id, user) do
    Place
    |> where(id: ^id)
    |> get_by_user_role(user)
    |> Repo.one()
    |> Repo.preload(:deficiencies)
  end

  def public_get(id) do
    Place
    |> where(id: ^id)
    |> where(status: :validated)
    |> Repo.one()
  end

  @doc """
  Create a place.
  """
  def insert(%{"deficiencies" => deficiencies} = attrs) do
    insert_result = %Place{} |> Place.insert_changeset(attrs) |> Repo.insert()

    with {:ok, %{id: place_id} = place} <- insert_result do
      update_place_deficiencies(place_id, deficiencies)
      {:ok, Repo.preload(place, :deficiencies)}
    end
  end

  @doc """
  Update a place.
  """
  def update(%{"id" => place_id, "deficiencies" => deficiencies} = attrs, user) do
    update_place_deficiencies(place_id, deficiencies)

    query = Place |> where(id: ^place_id) |> get_by_owner_user(user)

    update_result =
      case Repo.one(query) do
        nil ->
          {:error, :not_found}

        place ->
          place
          |> Place.update_changeset(attrs)
          |> delete_place_image_in_update(place)
          |> Repo.update()
      end

    with {:ok, data} <- update_result do
      {:ok, Repo.preload(data, :deficiencies)}
    end
  end

  defp update_place_deficiencies(_, []), do: nil

  defp update_place_deficiencies(place_id, deficiencies_ids) do
    if uuid_list?(deficiencies_ids) do
      Deficiency
      |> where([d], d.id in ^deficiencies_ids)
      |> Repo.update_all(set: [place_id: place_id])

      Deficiency
      |> where([d], d.place_id == ^place_id and d.id not in ^deficiencies_ids)
      |> Repo.update_all(set: [place_id: nil])
    end
  end

  defp delete_place_image_in_update(changeset, current_place) do
    new_image_data = Map.get(changeset.changes, :image)
    current_image_data = Map.get(current_place, :image)

    if new_image_data != nil and current_image_data != nil and
         new_image_data.file_name != current_image_data.file_name do
      PlaceImage.delete(current_place.image.file_name)
    end

    changeset
  end

  @doc """
  Hard delete a place.
  """
  def delete(id, user) do
    delete_operation = Place |> where(id: ^id) |> get_by_owner_user(user) |> Repo.delete_all()

    case delete_operation do
      {1, nil} -> :ok
      {0, nil} -> :not_found
    end
  end

  defp get_by_owner_user(query, user) do
    case user do
      %{role: :normal} ->
        where(query, user_id: ^user.id)

      _ ->
        query
    end
  end

  defp get_by_user_role_or_status(query, user, params) do
    mine = Map.get(params, :mine, false)

    cond do
      mine === true ->
        where(query, user_id: ^user.id)

      user.role == :normal ->
        where(query, [p], p.status == :validated or p.user_id == ^user.id)

      true ->
        query
    end
  end

  defp get_by_user_role(query, user) do
    case user do
      %{role: :normal} ->
        where(query, status: :validated)

      _ ->
        query
    end
  end

  defp get_by_statuses(query, params) do
    statuses = Map.get(params, :statuses)

    if statuses == nil do
      query
    else
      where(query, [p], p.status in ^statuses)
    end
  end

  defp get_by_location(query, params) do
    top_right = Map.get(params, :top_right)
    bottom_left = Map.get(params, :bottom_left)

    if top_right == nil or bottom_left == nil or length(top_right) != 2 or
         length(bottom_left) != 2 do
      query
    else
      # @todo
      # [top, right] = top_right
      # [bottom, left] = bottom_left
      # where(query, [p], p.latitude <= ^top and p.latitude >= ^bottom and p.longitude >= ^left and p.longitude <= ^right)
      query
    end
  end

  defp uuid_list?(data), do: not Enum.any?(data, &(Ecto.UUID.cast(&1) == :error))
end
