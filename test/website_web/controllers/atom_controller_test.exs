defmodule WebsiteWeb.AtomControllerTest do
  use WebsiteWeb.ConnCase

  test "GET /feed.atom", %{conn: conn} do
    conn = get(conn, Routes.atom_path(conn, :index))
    assert response(conn, 200) =~ "<title>Dave Lucia&apos;s Blog</title>"
  end
end
