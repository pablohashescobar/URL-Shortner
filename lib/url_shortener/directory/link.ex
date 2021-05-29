defmodule UrlShortener.Directory.Link do
  use Ecto.Schema
  import Ecto.Changeset

  alias UrlShortener.Accounts.User

  schema "links" do
    field :description, :string
    field :original_link, :string
    field :short_link, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:original_link, :short_link, :description])
    |> validate_required([:original_link, :short_link, :description])
  end
end
