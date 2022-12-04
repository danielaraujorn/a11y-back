defmodule AccessibilityReporterWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :accessibility_reporter

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_accessibility_reporter_key",
    signing_salt: "ZxFF5J7G"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve uploads
  plug Plug.Static, at: "/uploads", from: "uploads/"

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :accessibility_reporter
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  # Set up CORS here.
  plug Corsica, origins: "*", allow_credentials: true, allow_headers: :all
  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug AccessibilityReporterWeb.Router
end
