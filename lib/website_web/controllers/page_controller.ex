defmodule WebsiteWeb.PageController do
  use WebsiteWeb, :controller

  def index(conn, _params) do
    content = [
      "Surface: A Bridge to the JavaScript community",
      "Migrating from Kafka to RabbitMQ at SimpleBet: Why and How",
      "Betting on Observability at Simplebet",
      "Panel on Machine Learning on the BEAM",
      "Rustling up predictive sports betting models on the BEAM",
      "Battleship Elixir: JSON sunk my float",
      "Two Years of Elixir at The Outline",
      "Refactoring Elixir for maintainability",
      "Beyond Functions in Elixir: Refactoring for maintainability"
    ]

    render(conn, "index.html", content: content)
  end
end
