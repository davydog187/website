defmodule WebsiteWeb.Layouts do
  use Phoenix.Component

  import Phoenix.Controller, only: [get_csrf_token: 0]

  embed_templates "layouts/*"

  def root(assigns)
  def app(assigns)

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
