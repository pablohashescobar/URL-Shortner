defmodule UrlShortenerWeb.ClickView do
  use UrlShortenerWeb, :view
  alias UrlShortenerWeb.ClickView

  def render("index.json", %{clicks: clicks}) do
    %{data: render_many(clicks, ClickView, "click.json")}
  end

  def render("show.json", %{click: click}) do
    %{data: render_one(click, ClickView, "click.json")}
  end

  def render("click.json", %{click: click}) do
    %{id: click.id,
      browser_information: click.browser_information}
  end
end
