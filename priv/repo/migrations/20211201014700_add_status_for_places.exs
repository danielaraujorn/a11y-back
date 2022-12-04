defmodule AccessibilityReporter.Repo.Migrations.AddStatusForPlaces do
  use Ecto.Migration

  @type_name :place_status

  def change do
    execute(
      """
      CREATE TYPE #{@type_name}
        AS ENUM ('inProgress','validated','needChanges')
      """,
      "DROP TYPE #{@type_name}"
    )

    alter table(:places) do
      add :status, @type_name
    end
  end
end
