defmodule Website.Blog do
  use NimblePublisher,
    build: Website.Blog.Post,
    from: Application.app_dir(:website, "priv/blogs/**/*.md"),
    earmark_options: [
      postprocessor: &Website.Blog.Markdown.post_processor/1,
      code_class_prefix: "language-"
    ],
    as: :posts

  @content [
             %{
               type: :podcast,
               title: "Time series data with Timescale DB",
               link: "https://podcast.thinkingelixir.com/129",
               date: ~D[2022-12-13],
               event: "Thinking Elixir"
             },
             %{
               type: :podcast,
               title: "Understanding Observability in Elixir with Dave Lucia",
               link:
                 "https://topenddevs.com/podcasts/elixir-mix/episodes/understanding-observability-in-elixir-with-dave-lucia-emx-195",
               date: ~D[2022-11-23],
               event: "Elixir Mix"
             },
             %{
               type: :podcast,
               title: "Dave Lucia on Observability at Bitfo",
               link: "https://share.fireside.fm/episode/IAs5ixts+87YV43bE",
               date: ~D[2022-09-29],
               event: "Elixir Wizards"
             },
             %{
               type: :podcast,
               title: "Avro and Elixir with Dave Lucia",
               link: "https://podcast.thinkingelixir.com/97",
               date: ~D[2022-05-03],
               event: "Thinking Elixir"
             },
             %{
               type: :talk,
               title: "AvroEx 2.0 Improvements",
               link: "https://youtu.be/uT6EbezP12s",
               date: ~D[2022-04-29],
               event: "The Big Elixir"
             },
             %{
               type: :talk,
               title: "Surface: A bridge to the JavaScript community - Part two",
               link: "https://youtu.be/qJtlE1fmwrs",
               date: ~D[2022-04-29],
               event: "The Big Elixir"
             },
             %{
               type: :podcast,
               title: "RabbitMQ and Commanded at Simplebet with Dave Lucia",
               link:
                 "https://thinkingelixir.com/podcast-episodes/075-rabbitmq-and-commanded-at-simplebet-with-dave-lucia/",
               date: ~D[2021-11-30],
               event: "Thinking Elixir"
             },
             %{
               type: :talk,
               title: "Surface: A Bridge to the JavaScript community",
               link: "https://youtu.be/Lh5rA1pgWCk",
               date: ~D[2021-10-13],
               event: "ElixirConf 2021"
             },
             %{
               type: :talk,
               title: "Migrating from Kafka to RabbitMQ at Simplebet: Why and How",
               description: """
               At Simplebet, we are striving to make every moment of every sporting event a betting opportunity. In doing so, we initially chose Kafka to deliver market updates. The result was a setup which was difficult and expensive to maintain, and non-trivial for our customers to integrate with. After researching other delivery mechanisms, we migrated to RabbitMQ, as it provided us with a low-cost, low-latency alternative that satisfied our business needs. Best of all, it provided a familiar, standards-based means of integration for our customers with superior flexibility to what Kafka offers.

               In this talk, we will cover the technical and business reasons for why RabbitMQ has proven itself to be a great platform for building a B2B SaaS product, how it compares to other tools on the market, and where it excels in flexibility for our customers.
               """,
               link: "https://www.youtube.com/watch?v=dmBdFh5N1g4",
               event: "RabbitMQ Summit 2021",
               date: ~D[2021-07-13]
             },
             %{
               type: :talk,
               title: "Panel on Machine Learning on the BEAM",
               link: "https://youtu.be/lS5VQmvI7is",
               event: "Code BEAM V EU 2021",
               date: ~D[2021-05-19]
             },
             %{
               type: :talk,
               title: "Betting on Observability at Simplebet",
               link: "https://speakerdeck.com/davydog187/betting-on-observability-at-simplebet",
               event: "o11yfest",
               date: ~D[2021-05-18]
             },
             %{
               type: :podcast,
               title: "David Lucia, VP of Engineering at Simplebet",
               link: "https://alldus.com/blog/podcasts/aiinaction-david-lucia-simplebet/",
               event: "AI in Action",
               date: ~D[2020-07-21]
             },
             %{
               type: :talk,
               title: "Rustling up predictive sports betting models on the BEAM",
               link: "https://youtu.be/xmUfTl33-fU",
               event: "Code BEAM SF 2020",
               date: ~D[2020-03-05]
             },
             %{
               type: :podcast,
               title: "Dave Lucia on Rustler - Elixir Internals",
               link: "https://smartlogic.io/podcast/elixir-wizards/season-two-lucia/",
               event: "Elixir Wizards",
               date: ~D[2019-09-26]
             },
             %{
               type: :podcast,
               title: "The Dream Stack with Rust & Elixir",
               link:
                 "https://soundcloud.com/elixirtalk/episode-153-feat-dave-lucia-the-dream-stack-with-rust-elixir",
               event: "ElixirTalk",
               date: ~D[2019-08-22]
             },
             %{
               type: :podcast,
               title: "Distributed Elixir with Dave Lucia",
               link:
                 "https://play.acast.com/s/doesnotcompute/f666bfa1-063d-44f5-9c53-9e6e785cfb1f",
               event: "Does Not Compute",
               date: ~D[2019-06-11]
             },
             %{
               type: :podcast,
               title: "Integrating Rust and Elixir with Dave Lucia",
               link:
                 "https://play.acast.com/s/65f430a6-1eae-4ddd-bd3b-832dd9220203/85b3b7c2-3c29-489d-97b9-c407e00b82af",
               event: "Does Not Compute",
               date: ~D[2019-04-23]
             },
             %{
               type: :talk,
               title: "Refactoring Elixir for maintainability",
               link: "https://youtu.be/wvfhrvAFOoQ",
               event: "Code BEAM SF 2019",
               date: ~D[2019-02-28]
             },
             %{
               type: :blog,
               title: "Battleship Elixir: JSON sunk my float",
               link:
                 "https://medium.com/@davelucia/battleship-elixir-json-sunk-my-float-dc3df46447db",
               event: "medium",
               date: ~D[2018-11-26]
             },
             %{
               type: :blog,
               title: "Two Years of Elixir at The Outline",
               link:
                 "https://medium.com/@davelucia/two-years-of-elixir-at-the-outline-ad671a56c9ce",
               event: "medium",
               date: ~D[2018-09-24]
             },
             %{
               type: :blog,
               title: "Beyond Functions in Elixir: Refactoring for maintainability",
               link:
                 "https://medium.com/@davelucia/beyond-functions-in-elixir-refactoring-for-maintainability-5c73daba77f3",
               event: "medium",
               date: ~D[2017-12-06]
             }
           ]
           |> Enum.map(&Map.merge(&1, %{id: nil, description: &1.title}))

  @all Enum.sort_by(@posts ++ @content, & &1.date, {:desc, Date})

  def all, do: @all

  def get_post(id) do
    Enum.find(all(), &(&1.id == id))
  end
end
