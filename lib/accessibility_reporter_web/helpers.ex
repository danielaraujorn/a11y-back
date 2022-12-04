defmodule AccessibilityReporterWeb.Helpers do
  import Plug.Conn, only: [put_status: 2, halt: 1]
  import Phoenix.Controller, only: [put_view: 2, render: 3]

  def create_error_view(conn, status, errors) do
    conn
    |> put_status(status)
    |> put_view(AccessibilityReporterWeb.ErrorView)
    |> render(:"#{Plug.Conn.Status.code(status)}", errors: errors)
    |> halt()
  end
end
