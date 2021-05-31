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
    case create_link(link_params) do
      {:ok, link} ->
        conn
        |> redirect(to: Routes.link_path(conn, :show, link))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp create_link(link_params) do
    short_url = random_string(8)
    short_link = "http://localhost:4000/"<>short_url
    params = Map.put(link_params, "short_link", short_link)
    try do
      case Directory.create_link(params) do
        {:ok, link} ->
          {:ok, link}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:error, changeset}
      end
    rescue
      Ecto.ConstraintError ->
        create_link(params)
    end

  end

  defp random_string(string_length) do
    :crypto.strong_rand_bytes(string_length)
    |>Base.url_encode64()
    |>binary_part(0, string_length)
  end

  def show(conn, %{"id" => id}) do
    link = Directory.get_link!(id)
    render(conn, "show.json", link: link)
  end

  def show_link_with_clicks(conn, %{"link_id" => link_id, "click" => click}) do
    IO.inspect(link_id)
    IO.inspect(click)
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
