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

  describe "clicks" do
    alias UrlShortener.Directory.Click

    @valid_attrs %{browser_information: "some browser_information"}
    @update_attrs %{browser_information: "some updated browser_information"}
    @invalid_attrs %{browser_information: nil}

    def click_fixture(attrs \\ %{}) do
      {:ok, click} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Directory.create_click()

      click
    end

    test "list_clicks/0 returns all clicks" do
      click = click_fixture()
      assert Directory.list_clicks() == [click]
    end

    test "get_click!/1 returns the click with given id" do
      click = click_fixture()
      assert Directory.get_click!(click.id) == click
    end

    test "create_click/1 with valid data creates a click" do
      assert {:ok, %Click{} = click} = Directory.create_click(@valid_attrs)
      assert click.browser_information == "some browser_information"
    end

    test "create_click/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Directory.create_click(@invalid_attrs)
    end

    test "update_click/2 with valid data updates the click" do
      click = click_fixture()
      assert {:ok, %Click{} = click} = Directory.update_click(click, @update_attrs)
      assert click.browser_information == "some updated browser_information"
    end

    test "update_click/2 with invalid data returns error changeset" do
      click = click_fixture()
      assert {:error, %Ecto.Changeset{}} = Directory.update_click(click, @invalid_attrs)
      assert click == Directory.get_click!(click.id)
    end

    test "delete_click/1 deletes the click" do
      click = click_fixture()
      assert {:ok, %Click{}} = Directory.delete_click(click)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_click!(click.id) end
    end

    test "change_click/1 returns a click changeset" do
      click = click_fixture()
      assert %Ecto.Changeset{} = Directory.change_click(click)
    end
  end
end
