defmodule WebsiteWeb.BlogLive.Index do
  use WebsiteWeb, :live_view

  alias Website.Blog

  alias WebsiteWeb.Components.SVG

  alias Surface.Components.Link

  def mount(_, _, socket) do
    {:ok, assign(socket, filter: &Function.identity/1, filter_selected: :all)}
  end

  def handle_event("filter-content", %{"filter" => filter}, socket) do
    filter_selected = String.to_existing_atom(filter)

    filter =
      case filter_selected do
        :all -> &Function.identity/1
        filter -> fn content -> content.type == filter_selected end
      end

    {:noreply, assign(socket, filter: filter, filter_selected: filter_selected)}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :index, _) do
    title = ~s(Hi 👋 I'm <span class="font-medium">Dave Lucia</span>)

    assign(socket, content: Blog.all(), title: title, page_title: nil)
  end
end
