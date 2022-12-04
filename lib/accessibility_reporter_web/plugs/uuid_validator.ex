defmodule AccessibilityReporterWeb.Plugs.UUIDValidator do
  @moduledoc """
  Takes the params from `conn` and validates any IDs are in the
  correct format.
  """

  import Phoenix.Controller
  alias Plug.Conn

  @params_to_validate ~w[id]

  def init(opts \\ []), do: opts

  def call(conn, opts \\ [])

  def call(%Conn{params: params} = conn, _opts) do
    has_errors? =
      params
      |> Map.take(@params_to_validate)
      |> Map.values()
      |> Enum.any?(&(Ecto.UUID.cast(&1) == :error))

    case has_errors? do
      true ->
        halt_with(
          422,
          %{
            message: "Invalid params",
            detail: %{
              id: ["The ID provided was not in UUID format"]
            }
          },
          conn
        )

      _ ->
        conn
    end
  end

  def call(conn, _opts), do: conn

  defp halt_with(code, errors, conn) do
    conn
    |> Conn.put_status(code)
    |> put_view(AccessibilityReporterWeb.ErrorView)
    |> json(errors)
    |> Conn.halt()
  end
end
