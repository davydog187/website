defmodule WebsiteWeb.RssControllerTest do
  use WebsiteWeb.ConnCase

  test "GET /rss.xml", %{conn: conn} do
    conn = get(conn, "/rss.xml")
    assert response(conn, 200) =~ "<title>Dave Lucia's Blog</title>"
  end
end
