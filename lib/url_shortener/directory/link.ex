defmodule UrlShortener.Directory.Link do
  use Ecto.Schema
  import Ecto.Changeset

  alias UrlShortener.Accounts.User
  alias UrlShortener.Directory.Click

  schema "links" do
    field :description, :string
    field :original_link, :string
    field :short_link, :string
    field :hash_id, :string
    belongs_to :user, User
    has_many :clicks, Click

    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:original_link, :description, :short_link, :hash_id])
    |> cast_assoc(:clicks)
    |> validate_required([:original_link, :description])
  end
end
