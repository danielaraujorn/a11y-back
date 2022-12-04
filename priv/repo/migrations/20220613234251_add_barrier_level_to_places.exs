defmodule AccessibilityReporter.Repo.Migrations.AddBarrierLevelToPlaces do
  use Ecto.Migration

  def change do
    alter table(:places) do
      add :barrier_level, :integer
    end
  end
end
