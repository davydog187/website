defmodule WebsiteWeb.BlogLive do
  use WebsiteWeb, :live_view

  alias Website.Blog
  alias Website.Blog.Post

  alias WebsiteWeb.Components.SVG

  alias Surface.Components.Link

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :index, _) do
    title = ~s(Hi 👋 I'm <span class="font-medium">#{Enum.random(["David", "Dave"])} Lucia</span>)

    assign(socket, content: Blog.all(), title: title)
  end

  def apply_action(socket, :blog, %{"id" => id}) do
    post = Blog.get_post(id)
    assign(socket, post: Blog.get_post(id), title: post.title)
  end
end
