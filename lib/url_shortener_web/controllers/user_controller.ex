defmodule UrlShortenerWeb.UserController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Accounts
  alias UrlShortener.Accounts.User
  alias UrlShortenerWeb.Auth.Guardian


  action_fallback UrlShortenerWeb.FallbackController

  # def index(conn, _params) do
  #   users = Accounts.list_users()
  #   render(conn, "index.json", users: users)
  # end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
    {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("user.json", %{user: user, token: token})
    end
  end

  def signin(conn, %{"email" => email, "password" => password}) do
    with {:ok, user, token} <- Guardian.authenticate(email, password) do
      conn
      |> put_status(:created)
      |> render("user.json", %{user: user, token: token})
    end
  end

  def show_user(conn, %{}) do
    if Guardian.Plug.authenticated?(conn) do
      user = Guardian.Plug.current_resource(conn)
      render(conn, "show.json", user: user)
    end
  end

  # def show(conn, %{"id" => id}) do
  #   IO.inspect(conn)
  #   # user = Accounts.get_user!(id)
  #   # render(conn, "show.json", user: user)
  # end

  def update(conn, %{"user" => user_params}) do
    if Guardian.Plug.authenticated?(conn) do
      user = Guardian.Plug.current_resource(conn)
      with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
        render(conn, "show.json", user: user)
      end
    end
  end

  def delete(conn, %{}) do
    if Guardian.Plug.authenticated?(conn) do
      user = Guardian.Plug.current_resource(conn)
      IO.inspect(user.id)
      with {:ok, %User{}} <- Accounts.delete_user(user) do
        send_resp(conn, :no_content, "")
      end
    end
  end

end
