# def module UrlShortener.Accounts.Auth do


#   alias Comeonin.Bcrypt

#   def authenticate_user(username, plain_text_password) do
#     query = from u in User, where: u.username == ^username
#     Repo.one(query)
#     |> check_password(plain_text_password)
#   end

# end
