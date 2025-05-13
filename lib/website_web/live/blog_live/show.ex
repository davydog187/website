defmodule WebsiteWeb.BlogLive.Show do
  use WebsiteWeb, :live_view

  alias Surface.Components.Link

  alias Website.Blog
  alias Website.Blog.Post

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :show, %{"id" => id}) do
    post = Blog.get_post(id)

    assign(socket,
      post: Blog.get_post(id),
      title: post.title,
      description: post.description,
      page_title: post.title
    )
  end

  def render(assigns) do
    ~H"""
    <div class="relative mx-4 md:mx-0">
      <div class="absolute left-0 top-0 text-sm italic pb-2">
        Published <time datetime={@post.date}>{Calendar.strftime(@post.date, "%b %d, %Y")}</time>
      </div>
      <h1 class="py-8">{@title}</h1>
      <div>
        {Phoenix.HTML.raw(@post.body)}

        <div class="my-6 text-sm italics text-gray-600">
          See a mistake/bug? Edit this article on <.link href={Post.github_url(@post)}>Github</.link>
        </div>
      </div>
    </div>
    """
  end
end
