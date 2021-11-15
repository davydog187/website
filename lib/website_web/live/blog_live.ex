defmodule WebsiteWeb.BlogLive do
  use WebsiteWeb, :live_view

  alias WebsiteWeb.Components.SVG

  alias Surface.Components.Link

  def mount(_, _, socket) do
    content = [
      %{
        type: :talk,
        title: "Surface: A Bridge to the JavaScript community",
        link: "https://youtu.be/Lh5rA1pgWCk",
        date: ~D[2021-10-13],
        conference: "ElixirConf 2021"
      },
      %{
        type: :talk,
        title: "Migrating from Kafka to RabbitMQ at SimpleBet: Why and How",
        descrioption: """
        At Simplebet, we are striving to make every moment of every sporting event a betting opportunity. In doing so, we initially chose Kafka to deliver market updates. The result was a setup which was difficult and expensive to maintain, and non-trivial for our customers to integrate with. After researching other delivery mechanisms, we migrated to RabbitMQ, as it provided us with a low-cost, low-latency alternative that satisfied our business needs. Best of all, it provided a familiar, standards-based means of integration for our customers with superior flexibility to what Kafka offers.

        In this talk, we will cover the technical and business reasons for why RabbitMQ has proven itself to be a great platform for building a B2B SaaS product, how it compares to other tools on the market, and where it excels in flexibility for our customers.
        """,
        link: "https://github.com/davydog187/migrating_from_kafka",
        conference: "RabbitMQ Summit 2021",
        date: ~D[2021-07-13]
      },
      %{
        type: :talk,
        title: "Panel on Machine Learning on the BEAM",
        link: "https://youtu.be/lS5VQmvI7is",
        conference: "Code BEAM V EU 2021",
        date: ~D[2021-05-19]
      },
      %{
        type: :talk,
        title: "Betting on Observability at Simplebet",
        link: "https://speakerdeck.com/davydog187/betting-on-observability-at-simplebet",
        conference: "o11yfest",
        date: ~D[2021-05-18]
      },
      %{
        type: :talk,
        title: "Rustling up predictive sports betting models on the BEAM",
        link: "https://youtu.be/xmUfTl33-fU",
        conference: "Code BEAM SF 2020",
        date: ~D[2020-03-05]
      },
      %{type: :podcast, title: "The Dream Stack with Rust & Elixir", link: ""},
      %{type: :blog, title: "Battleship Elixir: JSON sunk my float", link: ""},
      %{type: :blog, title: "Two Years of Elixir at The Outline", link: ""},
      %{type: :talk, title: "Refactoring Elixir for maintainability", link: ""},
      %{
        type: :blog,
        title: "Beyond Functions in Elixir: Refactoring for maintainability",
        link: ""
      }
    ]

    {:ok, assign(socket, :content, content)}
  end
end
