defmodule WebsiteWeb.LayoutView do
  use WebsiteWeb, :view

  alias WebsiteWeb.Components.SVG

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  defp og_image(text) do
    uri = URI.parse("https://og-image-bay-phi.vercel.app")

    %URI{
      uri
      | path: "/" <> URI.encode(text || "Dave Lucia's Website"),
        query: URI.encode_query(%{widths: "408", heights: "612", fontSize: "80px"})
    }
    |> to_string
  end
end
