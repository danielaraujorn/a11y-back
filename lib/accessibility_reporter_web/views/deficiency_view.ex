defmodule AccessibilityReporterWeb.DeficiencyView do
  use AccessibilityReporterWeb, :view

  alias AccessibilityReporterWeb.DeficiencyView

  def render("deficiencies.json", %{deficiencies: deficiencies, total: total}) do
    %{
      data: %{
        deficiencies:
          render_many(deficiencies, DeficiencyView, "deficiency.json", as: :deficiency)
      },
      total: total
    }
  end

  def render("data_deficiency.json", %{deficiency: deficiency}) do
    %{data: render_one(deficiency, DeficiencyView, "deficiency.json", as: :deficiency)}
  end

  def render("deficiency.json", %{deficiency: deficiency}) do
    Map.take(deficiency, [:id, :name, :description, :inserted_at, :updated_at, :place_id])
  end
end
