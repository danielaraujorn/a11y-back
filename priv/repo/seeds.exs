# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     AccessibilityReporter.Repo.insert!(%AccessibilityReporter.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
import Ecto.Changeset

alias AccessibilityReporter.Repo
alias AccessibilityReporter.Accounts.Schema.User

Repo.delete_all(User)

%User{role: :admin}
|> User.registration_changeset(%{
  email: "admin@email.com",
  password: "@Admin12345"
})
|> put_change(:confirmed_at, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second))
|> Repo.insert!()

%User{role: :validator}
|> User.registration_changeset(%{
  email: "validator@email.com",
  password: "@Validator12345"
})
|> put_change(:confirmed_at, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second))
|> Repo.insert!()

%User{role: :normal}
|> User.registration_changeset(%{
  email: "normal@email.com",
  password: "@Normal12345"
})
|> put_change(:confirmed_at, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second))
|> Repo.insert!()
