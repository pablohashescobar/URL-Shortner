defmodule UrlShortener.Directory.Click do
  use Ecto.Schema
  import Ecto.Changeset

  alias UrlShortener.Directory.Link

  schema "clicks" do
    field :browser_information, :string
    belongs_to :link, Link

    timestamps()
  end

  @doc false
  def changeset(click, attrs) do
    click
    |> cast(attrs, [:browser_information])
    |> validate_required([:browser_information])
  end
end
