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
alias AccessibilityReporter.Deficiencies.Schema.Deficiency

Repo.delete_all(User)

%User{role: :admin}
|> User.registration_changeset(%{
  email: "admin@email.com",
  password: "@Senha12345"
})
|> put_change(:confirmed_at, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second))
|> Repo.insert!()

%User{role: :validator}
|> User.registration_changeset(%{
  email: "validator@email.com",
  password: "@Senha12345"
})
|> put_change(:confirmed_at, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second))
|> Repo.insert!()

%User{role: :normal}
|> User.registration_changeset(%{
  email: "normal1@email.com",
  password: "@Senha12345"
})
|> put_change(:confirmed_at, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second))
|> Repo.insert!()

%User{role: :normal}
|> User.registration_changeset(%{
  email: "normal2@email.com",
  password: "@Senha12345"
})
|> put_change(:confirmed_at, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second))
|> Repo.insert!()

%Deficiency{}
|> Deficiency.save_changeset(%{
  name: "Dificuldade na locomoção",
  description: "Dificuldade na locomoção"
})
|> Repo.insert!()

%Deficiency{}
|> Deficiency.save_changeset(%{
  name: "Baixa visão",
  description: "Baixa visão"
})
|> Repo.insert!()
