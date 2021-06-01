defmodule UrlShortenerWeb.Router do
  use UrlShortenerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug UrlShortenerWeb.Auth.Pipeline
  end

  scope "/api", UrlShortenerWeb do
    pipe_through :api
    post "/users/signup/", UserController, :create
    post "/users/signin/", UserController, :signin
    # get "/users/", UserController, :show_user
    post "/links/", LinkController, :create
    get "/link/:id/", LinkController, :show
    post "/link/:link_id/click", ClickController, :create
    get "/click/:id/", ClickController, :show
    put "/link/:id/", LinkController, :update
    delete "/link/:id/", LinkController, :delete
  end

  scope "/api", UrlShortenerWeb do
    pipe_through [:api, :auth]
    get "/users/", UserController, :show_user
    put "/users/", UserController, :update
    delete "/users/", UserController, :delete
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
