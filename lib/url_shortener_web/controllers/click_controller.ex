defmodule UrlShortenerWeb.ClickController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Directory
  alias UrlShortener.Directory.Click

  action_fallback UrlShortenerWeb.FallbackController

  def index(conn, _params) do
    clicks = Directory.list_clicks()
    render(conn, "index.json", clicks: clicks)
  end

  def create(conn, %{"click" => click_params}) do
    with {:ok, %Click{} = click} <- Directory.create_click(click_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.click_path(conn, :show, click))
      |> render("show.json", click: click)
    end
  end

  def show(conn, %{"id" => id}) do
    click = Directory.get_click!(id)
    render(conn, "show.json", click: click)
  end

  def update(conn, %{"id" => id, "click" => click_params}) do
    click = Directory.get_click!(id)

    with {:ok, %Click{} = click} <- Directory.update_click(click, click_params) do
      render(conn, "show.json", click: click)
    end
  end

  def delete(conn, %{"id" => id}) do
    click = Directory.get_click!(id)

    with {:ok, %Click{}} <- Directory.delete_click(click) do
      send_resp(conn, :no_content, "")
    end
  end
end
