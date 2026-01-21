defmodule WebsiteWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use WebsiteWeb, :controller
      use WebsiteWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def static_paths,
    do:
      ~w(assets fonts images icons favicon.ico favicon-16x16.png favicon-32x32.png apple-touch-icon.png robots.txt manifest.json)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      import LiveSvelte

      # Import common connection and controller functions to use in pipelines
      import Phoenix.Controller
      import Phoenix.LiveView.Router
      import Plug.Conn
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      unquote(verified_routes())
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: WebsiteWeb.Layouts]

      use Gettext, backend: WebsiteWeb.Gettext

      import Plug.Conn

      unquote(verified_routes())
    end
  end

  def live_view(opts \\ []) do
    opts = Keyword.put_new(opts, :layout, {WebsiteWeb.Layouts, :app})

    quote do
      use Phoenix.LiveView, unquote(opts)

      on_mount Sentry.LiveViewHook

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  defp html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      # HTML escaping functionality
      import Phoenix.HTML

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: WebsiteWeb.Endpoint,
        router: WebsiteWeb.Router,
        statics: WebsiteWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
