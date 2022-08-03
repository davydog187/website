defmodule Website.Blog.Markdown do
  def post_processor({"pre", attrs, children, meta}) do
    {"pre", [{"id", id(children)}, {"phx-hook", "prism"}, {"class", "highlight p-2"} | attrs],
     children, meta}
  end

  def post_processor({"blockquote", attrs, [{_tag, [{"class", admonition}], _children, _meta} | _], meta} = line) when admonition in ["info"] do
    Earmark.AstTools.merge_atts_in_node(line, class: "admonition admonition-#{admonition}")
  end

  def post_processor(other), do: other

  def to_html(string) do
    Earmark.as_html!(string, compact_output: true, postprocessor: &__MODULE__.post_processor/1)
  end

  defp id(ast) do
    ast |> text() |> hash() |> Base.encode64()
  end

  defp hash(iodata), do: :crypto.hash(:md5, iodata)

  defp text(list) when is_list(list) do
    Enum.map(list, &text/1)
  end

  defp text({_tag, _attrs, children, _meta}) do
    case children do
      [binary] when is_binary(binary) -> [binary]
      list -> text(list)
    end
  end
end
