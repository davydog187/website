defmodule WebsiteWeb.AtomController do
  use WebsiteWeb, :controller
  alias Website.Blog

  alias WebsiteWeb.Endpoint

  alias Calendar

  def index(conn, _params) do
    title = "Dave Lucia's Blog"
    url = Routes.blog_index_url(conn, :index)
    description = "The blog and personal website of Dave Lucia"

    posts = Blog.all()

    updated_at = Enum.max_by(posts, & &1.date, Date).date

    items =
      posts
      |> Enum.map(&entry/1)

    feed =
      {:feed, %{xmlns: "http://www.w3.org/2005/Atom"},
       [
         {:id, [], url},
         {:updated, [], to_datetime(updated_at)},
         {:link,
          %{href: Routes.atom_url(Endpoint, :index), rel: "self", type: "application/rss+xml"},
          []},
         {:author, [], [{:name, [], "Dave Lucia"}]},
         {:title, [], title},
         {:link, %{href: url}},
         {:subtitle, [], description}
       ] ++ items}

    conn
    |> put_resp_content_type("application/atom+xml")
    |> send_resp(200, feed |> XmlBuilder.document() |> XmlBuilder.generate())
  end

  defp entry(%{date: date, description: description, link: link, title: title}) do
    host = URI.new!(Endpoint.url())

    url =
      case URI.new!(link) do
        %URI{host: nil, path: path} -> %URI{host | path: path}
        url -> url
      end

    {:entry, %{},
     [
       {:title, [], title},
       {:summary, [], description},
       {:published, [], to_datetime(date)},
       {:updated, [], to_datetime(date)},
       {:link, %{href: to_string(url)}},
       {:id, [], url}
     ]}
  end

  defp to_datetime(date) do
    date |> DateTime.new!(~T[09:00:00.000], "Etc/UTC") |> DateTime.to_iso8601()
  end
end
