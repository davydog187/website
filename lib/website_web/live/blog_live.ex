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
    assign(socket, :content, Blog.all())
  end

  def apply_action(socket, :blog, %{"id" => id}) do
    assign(socket, :post, Blog.get_post(id))
  end
end
