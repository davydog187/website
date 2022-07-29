defmodule WebsiteWeb.BlogLive.Index do
  use WebsiteWeb, :live_view

  alias Website.Blog

  alias WebsiteWeb.Components.SVG

  alias Surface.Components.Link

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :index, _) do
    title = ~s(Hi 👋 I'm <span class="font-medium">Dave Lucia</span>)

    assign(socket, content: Blog.all(), title: title, page_title: nil)
  end
end
