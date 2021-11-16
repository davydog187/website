defmodule WebsiteWeb.BlogLiveTest do
  use WebsiteWeb.ConnCase, async: true

  test "it renders the page", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    assert render(view) =~ "Dave Lucia"
  end

  test "it redirects x-forwarded-proto", %{conn: conn} do
    assert {:error, {:redirect, %{to: to}}} =
             conn |> put_req_header("x-forwarded-proto", "http") |> live("/")

    assert to == "https://www.example.com/"
  end
end
