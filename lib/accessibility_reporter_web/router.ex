defmodule AccessibilityReporterWeb.Router do
  use AccessibilityReporterWeb, :router

  import AccessibilityReporterWeb.UserAuth

  pipeline :api_v1 do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AccessibilityReporterWeb.LayoutView, :root}
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug AccessibilityReporterWeb.Plugs.UUIDValidator
    plug AccessibilityReporterWeb.Plugs.Version, version: :v1
  end

  scope "/api/v1", AccessibilityReporterWeb do
    pipe_through :api_v1
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :api_v1
      live_dashboard "/dashboard", metrics: AccessibilityReporterWeb.Telemetry
    end
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :api_v1

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/api/v1", AccessibilityReporterWeb do
    pipe_through [:api_v1, :require_unauthenticated_user]

    post "/users/register", UserRegistrationController, :create
    post "/users/log_in", UserSessionController, :log_in
    post "/users/reset_password", UserResetPasswordController, :forgot_password
    patch "/users/reset_password/:token", UserResetPasswordController, :reset_password
  end

  scope "/api/v1", AccessibilityReporterWeb do
    pipe_through [:api_v1]

    post "/users/confirmation", UserConfirmationController, :create

    get "/users/confirmation/:token", UserConfirmationController, :update

    get "/places", PlaceController, :index
    get "/places/:id", PlaceController, :show

    get "/deficiencies", DeficiencyController, :index
    get "/deficiencies/:id", DeficiencyController, :show
  end

  scope "/api/v1", AccessibilityReporterWeb do
    pipe_through [:api_v1, :require_authenticated_user]

    get "/users/own", UserController, :own
    patch "/users/settings/email", UserSettingsController, :update_email
    patch "/users/settings/password", UserSettingsController, :update_password
    get "/users/settings/email_confirmation/:token", UserSettingsController, :confirm_email
    delete "/users/log_out", UserSessionController, :log_out
  end

  scope "/api/v1", AccessibilityReporterWeb do
    pipe_through [:api_v1, :require_authenticated_user, :require_admin_user]

    get "/users", UserController, :index
    get "/users/:id", UserController, :show
    patch "/users/:id/role", UserController, :update_role
  end

  scope "/api/v1", AccessibilityReporterWeb do
    pipe_through [:api_v1, :require_authenticated_user]

    post "/places", PlaceController, :create
    patch "/places/:id", PlaceController, :update
    delete "/places/:id", PlaceController, :delete

    post "/deficiencies", DeficiencyController, :create
    patch "/deficiencies/:id", DeficiencyController, :update
    delete "/deficiencies/:id", DeficiencyController, :delete
  end
end
