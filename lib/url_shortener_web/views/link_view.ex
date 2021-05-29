defmodule UrlShortenerWeb.LinkView do
  use UrlShortenerWeb, :view
  alias UrlShortenerWeb.LinkView

  def render("index.json", %{links: links}) do
    %{data: render_many(links, LinkView, "link.json")}
  end

  def render("show.json", %{link: link}) do
    %{data: render_one(link, LinkView, "link.json")}
  end

  def render("link.json", %{link: link}) do
    %{id: link.id,
      original_link: link.original_link,
      short_link: link.short_link,
      description: link.description}
  end
end
