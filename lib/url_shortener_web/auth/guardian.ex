defmodule UrlShortenerWeb.Auth.Guardian do
  use Guardian, otp_app: :url_shortener

  alias UrlShortener.Accounts

  def subject_for_token(user, _claims) do
    # Creating a subject for token creation
    # Here using id as a subject
    # email can be used as well
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    # Getting Id from the token
    id = claims["sub"]
    resource = Accounts.get_user!(id)
    {:ok,  resource}
  end

  def authenticate(email, password) do
    with {:ok, user} <- Accounts.get_by_email(email) do
      case validate_password(password, user.encrypted_password) do
        true ->
          create_token(user)
        false ->
          {:error, :unauthorized}
      end
    end
  end

  defp validate_password(password, encrypted_password) do
    Comeonin.Bcrypt.checkpw(password, encrypted_password)
  end

  defp create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user)
    {:ok, user, token}
  end

  def verify_token(token) do
    {:ok, claims} = decode_and_verify(token)
    {:ok, resource} = resource_from_claims(claims)
    resource
  end

end
