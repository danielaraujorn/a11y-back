defmodule AccessibilityReporter.Repo.Migrations.AddRoleForUsers do
  use Ecto.Migration

  @type_name :user_role

  def change do
    execute(
      """
      CREATE TYPE #{@type_name}
        AS ENUM ('admin','normal','validator')
      """,
      "DROP TYPE #{@type_name}"
    )

    alter table(:users) do
      add :role, @type_name
    end
  end
end
