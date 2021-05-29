defmodule UrlShortenerWeb.LinkController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Directory
  alias UrlShortener.Directory.Link

  action_fallback UrlShortenerWeb.FallbackController

  def index(conn, _params) do
    links = Directory.list_links()
    render(conn, "index.json", links: links)
  end

  def create(conn, %{"link" => link_params}) do
    with {:ok, %Link{} = link} <- Directory.create_link(link_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.link_path(conn, :show, link))
      |> render("show.json", link: link)
    end
  end

  def show(conn, %{"id" => id}) do
    link = Directory.get_link!(id)
    render(conn, "show.json", link: link)
  end

  def update(conn, %{"id" => id, "link" => link_params}) do
    link = Directory.get_link!(id)

    with {:ok, %Link{} = link} <- Directory.update_link(link, link_params) do
      render(conn, "show.json", link: link)
    end
  end

  def delete(conn, %{"id" => id}) do
    link = Directory.get_link!(id)

    with {:ok, %Link{}} <- Directory.delete_link(link) do
      send_resp(conn, :no_content, "")
    end
  end
end
