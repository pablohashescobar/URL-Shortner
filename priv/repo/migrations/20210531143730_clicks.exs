defmodule UrlShortener.Repo.Migrations.CreateClicks do
  use Ecto.Migration
  def change do
    create table(:clicks) do
      add :browser_information, :string
      add :link_id, references(:links, on_delete: :delete_all),
                    null: false
      timestamps(inserted_at: :created_at)
    end
    create index(:clicks, [:link_id])
  end
end
