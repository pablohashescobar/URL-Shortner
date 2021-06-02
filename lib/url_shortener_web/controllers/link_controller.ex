defmodule UrlShortenerWeb.LinkController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Directory
  alias UrlShortener.Directory.Link
  alias UrlShortenerWeb.Auth.Guardian

  action_fallback UrlShortenerWeb.FallbackController

  def index(conn, _params) do
    links = Directory.list_links()
    render(conn, "index.json", links: links)
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"link" => link_params}) do
    case create_link(conn, link_params) do
      {:ok, link} ->
        conn
        |> redirect(to: Routes.link_path(conn, :show, link))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp create_link(conn, link_params) do
    hash_id = random_string(8)
    short_link = "http://localhost:4000/"<>hash_id
    with_hash = Map.put(link_params, "short_link", short_link)
    params = Map.put(with_hash, "hash_id", hash_id)
    try do
      if Guardian.Plug.authenticated?(conn) do
        user = Guardian.Plug.current_resource(conn)
        case Directory.create_user_link(user, params) do
          {:ok, link} ->
            {:ok, link}
          {:error, %Ecto.Changeset{} = changeset} ->
            {:error, changeset}
        end
      else
        case Directory.create_link(params) do
          {:ok, link} ->
            {:ok, link}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:error, changeset}
        end
      end
    rescue
      Ecto.ConstraintError ->
        create_link(conn, params)
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

  def show_clicks_for_link(conn, %{"link_id" => link_id}) do
    clicks = Directory.get_clicks_for_link(link_id)
    IO.inspect(clicks)
    render(conn, "show_clicks.json", clicks: clicks)
  end

  def show_user_links(conn, %{}) do
    if Guardian.Plug.authenticated?(conn) do
      user = Guardian.Plug.current_resource(conn)
     with {:ok, links} <- Directory.get_user_links(user.id) do
      render(conn, "show_user_links.json", links: links)
     end
    end
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

  def redirect_to(conn, %{"hash_id" => hash_id}) do
    try do
      with {:ok, %Link{} = link} <- Directory.get_link_from_hash(hash_id) do
        redirect(conn, external: link.original_link)
      end
    rescue
      Ecto.NoResultsError ->
        redirect_to(conn, hash_id)
    end
  end
end
