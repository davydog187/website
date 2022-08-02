# Document Title
%{
    title: "Observing Elixir with OpenTelemetry, Lightstep, and Honeycomb",
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

If you've ever had questions like:

* Why does my `/api/foo/thing` route suddenly have a P50 of triple its normal latency?
* What is causing this memory spike in my application?
* Is this production outage affecting all of my users?

You might be in need of improving the observability of your system. Luckily, today we have standards, libraries, and tools available to answer the above questions much faster than before. 

## Can I get observability with an APM like New Relic, AppSignal, or DataDog?

Yes...and no. Application Performance Monitors (APMs) are a great way to get some observability of your system with little instrumentation. Out of the box, they will give you useful insights such as latency percentiles for each of the routes in your web application. From this metric data, you'll be able to see when you have a latency or rate spike on a particular route, due to increased traffic, a bug, or some infrastructure level problem. However, these tools only tell you **what** the problem is, they won't help you answer **why** it is happening, which is critical for the step of actually addressing any problems your application may be experiencing.

## You want telemetry data at different levels of granularity

In order to understand what's happening in your system, it's important to be able to see the big picture, and then zoom into various parts of your application to explore and discover regressions and issues. When I think about instrumenting my application with telemetry, I want the following kinds of data coming out of my system

1. **Tracing** - [High-cardinality, high-dimensional](https://www.honeycomb.io/blog/so-you-want-to-build-an-observability-tool/) spans annotating the critical operations of my application (Helps me explore, discover, and correlate specific issues)
2. **Metrics** - Low cardinality aggregate information (What's the summary of what's happening in the system over time?)
3. **Logging** - A time-series of specific events with pre-defined attributes
4. **Error Reporting** - Reporting and cataloging of errors and exceptions with stack traces

Now collecting all of this data is great, but data is not inherently valuable on its own. It is what you [can do with this data](https://lightstep.com/blog/three-pillars-zero-answers-towards-new-scorecard-observability) that is important. Advocates of observability such as [Charity Majors](https://charity.wtf/) and [Ben Sigelman](http://bensigelman.org/) argue that [you need high-cardinality ](https://thenewstack.io/observability-a-3-year-retrospective/) in order to debug production systems. To over-simplify, high-cardinality means that we are able to correlate on really specific information, like a user's unique identifier. Constrast that with low-cardinality data in metrics, where we collapse that information to provide a summary across an aggregate.

### If high-cardinality data is requisite for observability, then we need two things:

1. The ability to capture and export distributed traces of spans in our running system
2. A tool for analyzing our traces to correlate issues with root causes

We can achieve the above with [OpenTelemetry](https://opentelemetry.io/docs/instrumentation/erlang/) and an analysis tool like [Lightstep](https://www.honeycomb.io/) or [Honeycomb](https://www.honeycomb.io/).

## Instrumenting your Elixir app with OpenTelemetry

## Sending data to Lightstep or Honeycomb

## Why choose? Send to both using the otel-collector

