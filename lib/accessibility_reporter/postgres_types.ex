Postgrex.Types.define(
  AccessibilityReporter.PostgresTypes,
  [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions()
)
