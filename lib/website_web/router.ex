defmodule WebsiteWeb.Router do
  use WebsiteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {WebsiteWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :redirect_http
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WebsiteWeb do
    pipe_through :browser

    live "/", BlogLive, :index
  end

  def redirect_http(conn, _) do
    case get_req_header(conn, "x-forwarded-proto") do
      ["http"] -> conn |> redirect(external: https_url(conn)) |> halt()
      _ -> set_hsts_headers(conn)
    end
  end

  def set_hsts_headers(conn) do
    put_resp_header(
      conn,
      "strict-transport-security",
      "max-age=63072000; includeSubDomains; preload"
    )
  end

  defp https_url(%Plug.Conn{host: host, request_path: path}) do
    %URI{scheme: "https", host: host, path: path} |> URI.to_string()
  end
end
