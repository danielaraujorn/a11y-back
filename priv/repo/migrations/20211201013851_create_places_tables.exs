defmodule AccessibilityReporter.Repo.Migrations.CreatePlacesTables do
  use Ecto.Migration

  def change do
    create table(:places, primary_key: false) do
      add :id, :binary_id, primary_key: true, null: false
      add :description, :text, default: "", null: false
      add :image, :string
      add :location, :geometry
      add :validator_comments, :text, default: "", null: false
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false
      timestamps(type: :utc_datetime_usec)
    end
  end
end
