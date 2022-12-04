defmodule AccessibilityReporterWeb.Plugs.Version do
  @moduledoc """
  Takes the params from `conn` and add api version to `conn.assigns`
  """

  alias Plug.Conn
  def init(options), do: options

  def call(%Conn{params: %{"version" => version}} = conn, opts) do
    Conn.assign(conn, :version, Map.fetch!(opts, version))
  end

  def call(conn, _opts), do: conn
end
