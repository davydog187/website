# Elixir Observability: OpenTelemetry, Lightstep, Honeycomb",
%{
    title: "Elixir Observability: OpenTelemetry, Lightstep, Honeycomb",
    author: "Dave Lucia",
    tags: ~w(elixir observability lightstep),
    description: "How to integrate your Elixir application with Open Telemetry to make it observable in Lightstep and Honeycomb's reliability platform"
}
---
## What happens when your server goes bump in the night?
As an [Elixir developer](https://elixir-lang.org/), I get more sleep than most when an issue occurs at 2AM.  In my Elixir app, [supervisors](https://hexdocs.pm/elixir/1.13/Supervisor.html) restart processes when errors occur, keeping my systems available through dropped database connections, exceptions, etc.

When I wake up in the morning, its time to figure out what went wrong, fix the bug, and get back to feature development. *Finding the root-cause of issues is hard*, especially when the issue is not a simple amendment to an [if/else/case expression](https://hexdocs.pm/elixir/1.13/Kernel.SpecialForms.html#case/2), but a performance regression in your infrastructure or database. In order to get to the bottom of these problems, we must have a way to understand our running system. We can achieve this by practicing observability and putting the right tools in place. 

## What is observability?

Observability is simply the ability to observe your running system, with the purpose of understanding its behavior. Forget the [three pillars](https://youtu.be/EJV_CgiqlOE), or anything else you might have read, observability is all about information, tools, and analysis to get to the bottom of your burning questions faster.

> ### I'm hiring! {: .hiring}
> 
> If you're interested in observability, the BEAM, and Elixir, I'm hiring engineers at [Bitfo](https://bitfo.com).
>
> [Apply today!](https://jobs.gusto.com/postings/bitfo-backend-engineer-1bd420ee-e23b-4ad4-8cb2-8030a84c4089)

If you've ever had questions like:

* Why does the latency of the `/api/foo/thing` route suddenly triple the normal average?
* What is causing this memory spike in my application?
* Is this production outage affecting all of my users?

You might be in need of improving the observability of your system. Luckily, today we have standards, libraries, and tools available to answer the above questions much faster than before. 

## Can I get observability with an APM like New Relic, AppSignal, or DataDog?

Yes...and no. Application Performance Monitors (APMs) are a great way to get some observability of your system with little instrumentation. Out of the box, they will give you useful insights such as latency percentiles for each of the routes in your web application. From this metric data, you'll be able to see when you have a latency or rate spike on a particular route, due to increased traffic, a bug, or some infrastructure level problem. However, these tools only tell you **what** the problem is, they won't answer directly **why** it is happening, which is critical for the step of actually addressing any problems your application may be experiencing.

## You want telemetry data at different levels of granularity

> ### What is cardinality and dimensionality? {: .info}
> 
> *Cardinality* is a fancy word for the size of a given set. For instance, the cardinality of wheels in a bicycle is 2 -- that is, a given bicycle has 0, 1 or 2 wheels -- and the cardinality of the number of living humans is approximately 10 Billion. 
> When talking about observability, we need to worry about this because some metrics have high cardinality (i.e. a "user has logged in metric" has the same cardinality as the number of users) and some technologies can't handle that very well. We also need to keep in mind that the cardinality is composed, so the cardinality for the set of HTTP paths on your API is `number of URLs * number of HTTP methods`
>
> *Dimensionality* refers to the number of attributes your data has. Think of of it as the number of columns in your database table. The cardinality of each dimension is the set of possible values in that column.

In order to understand what's happening in your system, it's important to be able to see the big picture, and then zoom into various parts of your application to explore and discover regressions and issues. When I think about instrumenting my application with [telemetry](https://en.wikipedia.org/wiki/Telemetry), I want the following kinds of data coming out of my system

1. **Tracing** - [High-cardinality, high-dimensionality](https://www.honeycomb.io/blog/so-you-want-to-build-an-observability-tool/) spans annotating the critical operations of my application (Helps me explore, discover, and correlate specific issues)
2. **Metrics** - Low cardinality aggregate information (What's the summary of what's happening in the system over time?)
3. **Logging** - A time-series of specific events with pre-defined attributes
4. **Error Reporting** - Reporting and cataloging of errors and exceptions with stack traces

Now collecting all of this data is great, but data is not inherently valuable on its own. It is what you [can do with this data](https://lightstep.com/blog/three-pillars-zero-answers-towards-new-scorecard-observability) that is important. Advocates of observability such as [Charity Majors](https://charity.wtf/) and [Ben Sigelman](http://bensigelman.org/) argue that [you need high-cardinality ](https://thenewstack.io/observability-a-3-year-retrospective/) in order to debug production systems. To over-simplify, high-cardinality means that we are able to correlate on really specific information, like a user's unique identifier. Constrast that with low-cardinality data in metrics, where we collapse that information to provide a summary across an aggregate.

### If high-cardinality data is requisite for observability, then we need two things:

1. The ability to capture and export distributed traces of spans in our running system
2. A tool for analyzing our traces to correlate issues with root causes

We can achieve the above with [OpenTelemetry](https://opentelemetry.io/docs/instrumentation/erlang/) and an analysis tool like [Lightstep](https://www.lightstep.com/) or [Honeycomb](https://www.honeycomb.io/).

## Instrumenting your Elixir app with OpenTelemetry

Let's instrument a brand new Elixir app with OpenTelemetry. For this guide, I'll assume you have a [Phoenix application](https://www.phoenixframework.org/) using [Elixir 1.13](https://elixir-lang.org/blog/2021/12/03/elixir-v1-13-0-released/) or newer.

### Install Dependencies

First we'll add the required dependencies into our `mix.exs` file for producing traces and spans with OpenTelemetry

> ### Is it safe to use rc releases? {: .info}
>
> You'll notice a number of OpenTelemetry libraries are in `rc`, or release-candidate status. Using release candidates carries some inherent risk, but are generally safe to use. They are put in this status to indicate that there are some changes that have not fully stabilized, but they are nearing a major release.

```elixir
# mix.exs
{:opentelemetry, "~> 1.0"},
{:opentelemetry_api, "~> 1.0"},
{:opentelemetry_exporter, "~> 1.0", only: :prod},
```

Additionally, you should install instrumentation libraries for any of the popular libraries and frameworks you may be using

```elixir
# mix.exs
{:opentelemetry_ecto, "~> 1.0"},
{:opentelemetry_liveview, "~> 1.0.0-rc.4"},
{:opentelemetry_oban, "~> 0.2.0-rc.5"},
{:opentelemetry_phoenix, "~> 1.0"},
```

Once you run `mix deps.get`, its time to instrument your application

### Instrumenting libraries

As we saw above, there are many packages above that can give you great tracing to the libraries you're already using. These libraries typically work by hooking into [telemetry](https://hexdocs.pm/telemetry/readme.html) events produced by these libraries and converting them into OpenTelemetry spans. Note that this is a point of confusion for many people, as the `telemetry` library is an BEAM-specific package for producing telemetry data inside a BEAM application, and is not directly related to OpenTelemetry. However, it is a useful mechanism for libraries, such as [opentelemetry_ecto](https://github.com/open-telemetry/opentelemetry-erlang-contrib/blob/main/instrumentation/opentelemetry_ecto/lib/opentelemetry_ecto.ex#L42) to hook into for producing spans.

To start using these libraries, most simply require calling a `setup/1` function in our Application supervision tree.

> #### `:telemetry` vs `OpenTelemetry`, what's the difference? {: .info}
>
> `:telemetry` is an [Erlang](https://www.erlang.org/) library for providing a language & library agnostic means to produce and hook into telemetry events in a BEAM application. I recommend reading the [source code](https://github.com/beam-telemetry/telemetry/blob/main/src/telemetry.erl#L153) to demystify how it works, its implementation is quite clever. Check the [Phoenix Telemetry guide](https://hexdocs.pm/phoenix/telemetry.html) for learning how you can integrate `:telemetry` events into your application.
>
> [OpenTelemetry](https://opentelemetry.io/) is a language-agnostic set of tools, APIs, and SDKs for instrumenting, generating, collecting, and exporting telemetry data. Since most libraries produce `:telemetry` events, libraries such as [opentelemetry_phoenix](https://github.com/open-telemetry/opentelemetry-erlang-contrib/tree/main/instrumentation/opentelemetry_phoenix) hook into these events and convert them into spans using the [Erlang/Elixir OpenTelemetry library](https://github.com/open-telemetry/opentelemetry-erlang).

```elixir
# lib/my_app/application.ex
defmodule MyApp.Application do
  use Application
 
  def start(_type, _args) do
    OpentelemetryPhoenix.setup()
    OpentelemetryLiveView.setup()
    OpentelemetryEcto.setup([:my_app, :repo])

    # Only trace jobs to minimize noise
    OpentelemetryOban.setup(trace: [:jobs])
  
    ...
  end
end
```

### Instrumenting your application

With distributed tracing, it is recommended to start by tracing the [boundaries of your application](https://vi.to/hubs/o11yfest/videos/3149?v=%2Fvideos%2F3149). As we saw above, we can get spans into many of the entrypoints of our application just by using out-of-the-box libraries. However, there may be internal operations that may need spans, or maybe you want to add additional information to spans that are already being produced, such as adding the `user_id` to every span in your [plug](https://hexdocs.pm/plug/readme.html) pipeline.

### Configuration

Before we start sending data, we need to add a few configurations to our app

1. Run the `opentelemetry` application as temporary

Although observability is important, if it fails it shouldn't take your app down with it! To ensure this is the case, we need to make sure `opentelemetry` runs in temporary mode

```elixir
# mix.exs

def project do
  [
    ...,
    releases: [
      my_app: [
          applications: [my_app: :permanent, opentelemetry: :temporary]
      ]
    ]
  ]
end
```

2. Set your runtime specific attributes for your production environment

My application currently runs in [fly.io](https://fly.io). In the startup script for my Elixir release, I add the following annotations so that every span has information about the server and environment it is executed in. Note that there are more options that you can set, see the [OpenTelemetry semantic conventions for the cloud](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/resource/semantic_conventions/cloud.md)

```bash
# rel/overlays/bin/server

#!/bin/sh
cd -P -- "$(dirname -- "$0")"

read -r -d '' attributes << EOM
service.name=${FLY_APP_NAME},
service.instance.id=${FLY_ALLOC_ID},
cloud.provider=fly_io,
cloud.region.id=${FLY_REGION}
EOM

readonly OTEL_RESOURCE_ATTRIBUTES=`echo $attributes | sed 's/[[:space:]]//g'`

OTEL_RESOURCE_ATTRIBUTES=${OTEL_RESOURCE_ATTRIBUTES} \
    PHX_SERVER=true \
    exec ./bitfo start
```

3. Last but not least, we must configure `opentelemetry` to process our spans

In dev, we can validate our setup using the [standard output exporter](https://github.com/open-telemetry/opentelemetry-erlang/blob/main/apps/opentelemetry/src/otel_exporter_stdout.erl). I like to make this optional with an environment variable, so that I can turn off span production via the  [`:otel_tracer_noop`](https://github.com/open-telemetry/opentelemetry-erlang/blob/main/apps/opentelemetry_api/src/otel_tracer_noop.erl) tracer when I'm not testing my OpenTelemetry setup.

```elixir
# config/{dev,test}.exs

# Turn on logging spans to the console via
# DEBUG_OTEL=true mix phx.server

if System.get_env("DEBUG_OTEL") == "true" do
  config :opentelemetry, :processors,
    otel_batch_processor: %{
      exporter: {:otel_exporter_stdout, []}
    }
else
  config :opentelemetry,
    :tracer,
    :otel_tracer_noop
end
```

However, in production we want them to be processed and sent to our tooling of choice, using the [`otlp` protocol](https://opentelemetry.io/docs/reference/specification/protocol/)

```elixir
# config/runtime.exs

config :opentelemetry,
  span_processor: :batch,
  exporter: :otlp
```

## Sending data to Lightstep or Honeycomb

Now its time to send data to an observability vendor for analysis. [Honeycomb](https://www.honeycomb.io/) and [Lightstep](https://lightstep.com/) are both excellent products with generous free tiers for getting started. I am personally partial to Lightstep, and did a [case-study with them while at Simplebet](https://lightstep.com/case-studies/simplebet). In my opinion, Lightstep makes it a bit easier to get started with features such as their [Service Directory](https://docs.lightstep.com/docs/view-individual-service-performance). However, both platforms have their strengths and weaknesses, and you cannot go wrong with either.

### Configuring Elixir for Lightstep

Sign up for lightstep, grab your [access token](https://docs.lightstep.com/docs/create-and-manage-access-tokens), and add the following to your configuration

```elixir
# runtime.exs
config :opentelemetry_exporter,
  otlp_protocol: :http_protobuf,
  otlp_traces_endpoint: "https://ingest.lightstep.com:443/traces/otlp/v0.9",
  otlp_compression: :gzip,
  otlp_headers: [
    {"lightstep-access-token", System.get_env("LIGHTSTEP_ACCESS_TOKEN")}
  ]
```

### Configuring Elixir for Honeycomb 

Sign up for Honeycomb, grab your API key, then

```elixir
# runtime.exs
config :opentelemetry_exporter,
  otlp_protocol: :http_protobuf,
  otlp_endpoint: "https://api.honeycomb.io:443",
  otlp_headers: [
    {"x-honeycomb-team", System.get_env("HONEYCOMB_API_KEY")},
    {"x-honeycomb-dataset", System.get_env("FLY_APP_NAME")}
  ]
```

## Why choose? Send to both using the otel-collector

Alright Veruca Salt, you want the whole world. Part of the selling points of OpenTelemetry is that it aims to provide a vendor-agnostic means for shipping telemetry data to any vendor. If you have the means, deploying the [otel-collector](https://opentelemetry.io/docs/collector/) into your infrastructure will allow your application to directly export spans to the collector, and let the collector pick and choose one more more vendors to export spans to. 

This means that you can use Honeycomb and Lightstep at the same time, compare and contrast their feature sets, and then choose whom you'd like to upgrade your plan with, if you need to.

## Analyzing OpenTelemetry data with Lightstep

Now that you're producing OpenTelemetry data, you will begin to see latency and error data populate in your Service Directory. This is a great starting point for exploring the operations in your application

![](/images/lightstep-service-directory.png)

However, the real value of Lightstep is using [streams](https://docs.lightstep.com/docs/monitor-a-service-level-indicator-with-streams) and finding root-causes to issues using their [correlation analysis tools](https://docs.lightstep.com/docs/find-correlated-areas-of-latency). Take a tour of their documentation and learn how to make effective use of their reliability platform.

## Conclusion

This is only the tip of the iceberg for getting started with observability. For actually correlating production issues with these tools, please dig into the excellent documentation of [Lightstep](https://docs.lightstep.com/) and [Honeycomb](https://docs.honeycomb.io/) for setting up queries, dashboards, alerts, and more. 

If you're interested in getting deeper, the amazing [Charity Majors](https://charity.wtf), [Liz Fong-Jones](https://www.lizthegrey.com/), and [George Miranda](https://twitter.com/gmiranda23?s=20&t=mKz2oJPxqn42zXU35Q8dmA) wrote a book called [Observability Engineerging: Achieving Production Excellence](https://www.oreilly.com/library/view/observability-engineering/9781492076438/) that promises to go way deeper on the topic of observability.

For Elixir-specific issues, hit me up on [Twitter](https://twitter.com/davydog187) or the fine folks of the [Erlang Obserability Working Group](https://erlef.org/wg/observability). And if you are interested, please consider supporting them or joining their working group, they can always use an extra hand!

## Special Thanks

Thank you to all those who [offered to proofread and fact-check](https://twitter.com/davydog187/status/1554527578060472320?s=20&t=Hzb5paV375c0ghKUCYC2pg) this post. Special thanks to [Bernardo Amorim](https://twitter.com/BernardoDCGA), [Herminio Torres](https://twitter.com/herminiotorres), [Michael Crumm](https://twitter.com/mcrumm), [Paulo Valente](https://twitter.com/polvalente), and [Sundi Myint](https://twitter.com/sundikhin) who all provided invaluable feedback to this post.


Thanks for reading!

