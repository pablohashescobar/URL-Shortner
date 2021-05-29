defmodule UrlShortener.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :original_link, :string
      add :short_link, :string
      add :description, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(inserted_at: :created_at)
    end

    create index(:links, [:user_id])
  end
end
