defmodule UrlShortenerWeb.Router do
  use UrlShortenerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug UrlShortenerWeb.Auth.Pipeline
  end


  scope "/", UrlShortenerWeb do
    get "/:hash_id/", LinkController, :redirect_to
  end

  scope "/api", UrlShortenerWeb do
    pipe_through :api
    post "/users/signup/", UserController, :create
    post "/users/signin/", UserController, :signin
    post "/links/", LinkController, :create
    get "/link/:id/", LinkController, :show
    post "/link/:link_id/click/", ClickController, :create
    get "/link/:link_id/click/", LinkController, :show_clicks_for_link
    get "/click/:id/", ClickController, :show
    put "/link/:id/", LinkController, :update
    delete "/link/:id/", LinkController, :delete
  end

  scope "/api", UrlShortenerWeb do
    pipe_through [:api, :auth]
    get "/users/", UserController, :show_user
    put "/users/", UserController, :update
    delete "/users/", UserController, :delete
    post "/users/links/", LinkController, :create
    get "/users/links/", LinkController, :show_user_links
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: UrlShortenerWeb.Telemetry
    end
  end
end
