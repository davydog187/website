defmodule Website.MarkdownTest do
  use ExUnit.Case

  test "it annotates code blocks" do
    text = """
    ```elixir
    Module.foo()
    ```
    """

    assert to_html(text) ==
             """
             <pre id=\"m9CTP/+ZIIYCi/8AgLaHtg==\" phx-hook=\"prism\" class="highlight p-2"><code class="elixir">Module.foo()</code></pre>
             """
  end

  defp to_html(text) do
    Earmark.as_html!(text, postprocessor: &Website.Blog.Markdown.post_processor/1)
  end
end
