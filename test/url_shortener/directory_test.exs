defmodule UrlShortener.DirectoryTest do
  use UrlShortener.DataCase

  alias UrlShortener.Directory

  describe "links" do
    alias UrlShortener.Directory.Link

    @valid_attrs %{description: "some description", original_link: "some original_link", short_link: "some short_link"}
    @update_attrs %{description: "some updated description", original_link: "some updated original_link", short_link: "some updated short_link"}
    @invalid_attrs %{description: nil, original_link: nil, short_link: nil}

    def link_fixture(attrs \\ %{}) do
      {:ok, link} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Directory.create_link()

      link
    end

    test "list_links/0 returns all links" do
      link = link_fixture()
      assert Directory.list_links() == [link]
    end

    test "get_link!/1 returns the link with given id" do
      link = link_fixture()
      assert Directory.get_link!(link.id) == link
    end

    test "create_link/1 with valid data creates a link" do
      assert {:ok, %Link{} = link} = Directory.create_link(@valid_attrs)
      assert link.description == "some description"
      assert link.original_link == "some original_link"
      assert link.short_link == "some short_link"
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Directory.create_link(@invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      link = link_fixture()
      assert {:ok, %Link{} = link} = Directory.update_link(link, @update_attrs)
      assert link.description == "some updated description"
      assert link.original_link == "some updated original_link"
      assert link.short_link == "some updated short_link"
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = link_fixture()
      assert {:error, %Ecto.Changeset{}} = Directory.update_link(link, @invalid_attrs)
      assert link == Directory.get_link!(link.id)
    end

    test "delete_link/1 deletes the link" do
      link = link_fixture()
      assert {:ok, %Link{}} = Directory.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_link!(link.id) end
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = Directory.change_link(link)
    end
  end
end
