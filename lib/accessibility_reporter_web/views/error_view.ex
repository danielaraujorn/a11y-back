defmodule AccessibilityReporterWeb.ErrorView do
  use AccessibilityReporterWeb, :view

  def render(_template, %{errors: errors}) do
    errors
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{message: Phoenix.Controller.status_message_from_template(template)}
  end
end
