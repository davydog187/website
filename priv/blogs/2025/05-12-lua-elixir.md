# /blogs/2025/05-12-lua-elixir.md
%{
    title: "Introducing Lua for Elixir",
    author: "Dave Lucia",
    tags: ~w(elixir),
    description: "Execute sandboxed Lua code on the BEAM VM using Luerl"
}
---

The first stable release of the Elixir library, [Lua v0.1.0](https://hexdocs.pm/lua/Lua.html), has been released to [hex.pm](https://hex.pm/packages/lua)!

Lua is a library that allows you to execute arbitrary, sandboxed [Lua](https://www.lua.org/) programs directly on the BEAM VM. This is **not** embedding the C Lua runtime and compiler, but rather a complete implementation of Lua 1.3. This feat is made possible by the underlying [Luerl library](https://github.com/rvirding/luerl), which implements a Lua parser, compiler, and runtime, all in Erlang.

The Lua Elixir library extends the capabilities of the Luerl library, improving error messages and providing robust documentation. 

Feature highlights include:

### Extending Lua with Elixir APIs

The Lua Elixir library has a `deflua` macro for easily expressing APIs in Elixir that can be exposed to Lua with `Lua.load_api/2`

```elixir
defmodule MyAPI do
  use Lua.API
      
  deflua double(v), do: 2 * v
end

import Lua, only: [sigil_LUA: 2]
    
lua = Lua.new() |> Lua.load_api(MyAPI)

{[10], _} = Lua.eval!(lua, ~LUA[return double(5)])
```

### Compile-time syntax evaluation

A `~LUA` sigil is exposed, allowing the validation of Lua syntax at Elixir compile time.

```elixir
iex> import Lua, only: [sigil_LUA: 2]

#iex> {[4], _} = Lua.eval!(~LUA[return 2 +])
** (Lua.CompilerException) Failed to compile Lua!
```

### Robust documentation

See the [Lua Hex docs](https://hexdocs.pm/lua/Lua.html) for detailed documentation and examples for working with Lua and Luerl.


A [Livebook](https://hexdocs.pm/lua/working-with-lua.html) is also available to get you started.

## Born at TV Labs

The Lua Elixir library started as a proof of concept at [TV Labs](https://tvlabs.ai/), where I am co-founder and CTO. At TV Labs, we needed to execute arbitrary code to allow our customers to write high-level integration tests against physical televisions and other streaming media devices. What started as a prototype led to diving deep into the particulars of Luerl, improving its usability and error messages, while making it easy to use from Elixir. TV Labs uses Lua as a compilation target for its [drag and drop Automation builder](https://docs.tvlabs.ai/automation/what-is-automation), where users can specify the high-level workflow of their tests, and we handle the scheduling and underlying execution.

The Elixir Lua library and Luerl have allowed us to build a working solution for vision-based integration tests on physical devices, without needing to orchestrate additional Javascript or Python virtual machines, and executing the code on compute right next to the physical device.

## How Luerl came to be

Robert Virding is a living legend. Beyond being a [famous movie star](https://youtu.be/xrIjfIjssLE?si=V8rbI0QZM5p6CpvB), Robert is best known for collaborating with [Joe Armstrong](https://en.wikipedia.org/wiki/Joe_Armstrong_(programmer)) and Mike Williams at Ericsson in the mid-80s to create the [Erlang Programming Language](https://www.erlang.org/). Erlang is originally known for its use in telecommunications and its properties of fault-tolerance, concurrency, and immutable data, but is now regarded as a general purpose language, with its virtual machine, the BEAM VM, powering many languages including Elixir and Gleam. Since it wasn't fun to just create *one* programming language, Robert also created [Lisp flavored Erlang (LFE)](https://github.com/lfe/lfe), a Prolog interpreter in Erlang called [Erlog](https://github.com/rvirding/erlog), and of course, an implementation of Lua called [Luerl](https://www.luerl.org/).

During [Code BEAM EU 2024](https://codebeameurope.com/), I had the honor of [giving a talk](https://codebeameurope.com/talks/lua-on-the-beam/) with Robert. Since Luerl seemed to be a side project for him, I asked him why he bothered creating it in the first place. Robert smirked and said:

> I wrote a Prolog on Erlang, that was fun. Then I wrote a functional Lisp in Erlang, that was fun too. But then I realized that it would be neat to implement an imperative or object-oriented language on the BEAM, so I picked Lua and had at it. That's how Luerl was born.

If I've learned anything from this experience and collaborating with Robert, it's that he still gets immense joy from creating and experimenting, and Luerl is one of those many examples.

## The future of Lua and Luerl

Lua has been a great foundation for building our automation platform at TV Labs; however, there are many improvements needed in Luerl to make it more useful:

1. The quality of error messages needs to be dramatically improved
2. Stacktraces often lack useful context and information
3. Documentation and examples need significant work
4. Sandboxing features related to memory need more examination and exploration
5. Deeper integration with the larger Lua ecosystem

To that end, Robert and I have discussed merging the Elixir Lua library into Luerl. We hope to do this and release a 2.0.0 version of Luerl, continuing to improve documentation, remove deprecated interfaces, and dramatically improve error messages and stack traces.

If you're interested in getting involved, join the [Slack](https://erlef.org/slack-invite/luerl) or [Discord](https://discord.gg/TW78MycH), or [open an issue on Github](https://github.com/rvirding/luerl/issues/new).

Thanks!
