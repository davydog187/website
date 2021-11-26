defmodule Website.Blog.Markdown do
  def post_processor({"pre", attrs, children, meta}) do
    {"pre", [{"class", "highlight p-2"} | attrs], ["nope"], meta}
  end

  def post_processor({"code", attrs, children, meta} = node) do
    IO.inspect(attrs, label: "attr")
    IO.inspect(children)
    IO.inspect(meta, label: "meta")
    attrs = [{"class", "whatup"} | attrs]
    children = children |> to_string() |> Makeup.highlight()

    {"code", attrs, ["farts"], meta}
  end

  def post_processor(other), do: other

  def to_html(string) do
    Earmark.as_html!(string, compact_output: true, postprocessor: &__MODULE__.post_processor/1)
  end
end
