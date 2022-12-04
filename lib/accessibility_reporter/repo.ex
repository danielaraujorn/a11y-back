defmodule AccessibilityReporter.Repo do
  use Ecto.Repo,
    otp_app: :accessibility_reporter,
    adapter: Ecto.Adapters.Postgres
end
