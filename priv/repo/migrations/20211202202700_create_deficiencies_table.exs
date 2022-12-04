defmodule AccessibilityReporter.Repo.Migrations.CreateDeficienciesTable do
  use Ecto.Migration

  def change do
    create table(:deficiencies, primary_key: false) do
      add :id, :binary_id, primary_key: true, null: false
      add :name, :string, default: "", null: false
      add :description, :text, default: "", null: false
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :place_id, references(:places, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end
  end
end
