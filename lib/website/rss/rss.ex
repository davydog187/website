defmodule Website.Rss do
  def feed(channel, items) do
    """
    <?xml version="1.0" encoding="utf-8"?>
    <rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
    <channel>
    <atom:link href="#{WebsiteWeb.Endpoint.url()}/rss.xml" rel="self" type="application/rss+xml" />
    #{channel}#{Enum.join(items, "")}</channel>
    </rss>
    """
  end

  def item(%{date: date, description: description, id: id, link: link, title: title}) do
    """
    <item>
      <title>#{title}</title>
      <description>#{description}></description>
      <pubDate>#{date}</pubDate>
      <link>#{WebsiteWeb.Endpoint.url()}#{link}</link>
      <guid>#{WebsiteWeb.Endpoint.url()}#{link}</guid>
    </item>
    """
  end

  def channel(title, link, desc, lang) do
    """
      <title>#{title}</title>
      <link>#{link}</link>
      <description>#{desc}</description>
      <language>#{lang}</language>
    """
  end
end
