defmodule WebsiteWeb.RssController do
  use WebsiteWeb, :controller
  alias Website.Rss
  alias Website.Blog

  alias Calendar

  def index(conn, _params) do
    channel =
      Rss.channel(
        "Dave Lucia's Blog",
        "https://davelucia.com",
        "The blog and personal website of Dave Lucia",
        "en-us"
      )

    items =
      Blog.all()
      |> Enum.filter(&match?(%Website.Blog.Post{}, &1))
      |> Enum.map(fn x -> Rss.item(x) end)

    feed = Rss.feed(channel, items)

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, feed)
  end
end
