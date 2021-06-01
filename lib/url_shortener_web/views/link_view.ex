defmodule UrlShortenerWeb.LinkView do
  use UrlShortenerWeb, :view
  alias UrlShortenerWeb.{LinkView, ClickView}

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
      description: link.description,
      clicks: render_many(link.clicks, ClickView, "click.json")
    }
  end

  def render("link_with_clicks.json", %{link: link}) do
    %{
      id: link.id,
      original_link: link.original_link,
      short_link: link.short_link,
      description: link.description,
      clicks: render_many(link.clicks, ClickView, "click.json")
    }
  end

  def render("show_user_links.json", %{links: links}) do
    %{data: render_many(links, LinkView, "user_links.json")}
  end

  def render("user_links.json", %{link: link}) do
    %{
      id: link.id,
      original_link: link.original_link,
      short_link: link.short_link,
      description: link.description
    }
  end
end
