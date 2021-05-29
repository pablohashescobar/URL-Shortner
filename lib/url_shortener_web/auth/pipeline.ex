defmodule UrlShortenerWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :busi_api,
    module: UrlShortenerWeb.Auth.Guardian,
    error_handler: UrlShortenerWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
