defmodule Website.Blog.Post do
  @enforce_keys [:id, :author, :title, :body, :description, :tags, :date, :type, :event, :link]
  defstruct [:id, :author, :title, :body, :description, :tags, :date, :type, :event, :link]

  def path(id) do
    "/blog/#{id}"
  end

  def build(filename, attrs, body) do
    [year, month_day_id] =
      filename
      |> Path.rootname()
      |> Path.split()
      |> Enum.take(-2)

    [month, day, id] = String.split(month_day_id, "-", parts: 3)
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")

    struct!(
      __MODULE__,
      [id: id, type: :blog, event: "davelucia.com", link: path(id), date: date, body: body] ++
        Map.to_list(attrs)
    )
  end
end
