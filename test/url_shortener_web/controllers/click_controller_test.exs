defmodule UrlShortenerWeb.ClickControllerTest do
  use UrlShortenerWeb.ConnCase

  alias UrlShortener.Directory
  alias UrlShortener.Directory.Click

  @create_attrs %{
    browser_information: "some browser_information"
  }
  @update_attrs %{
    browser_information: "some updated browser_information"
  }
  @invalid_attrs %{browser_information: nil}

  def fixture(:click) do
    {:ok, click} = Directory.create_click(@create_attrs)
    click
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all clicks", %{conn: conn} do
      conn = get(conn, Routes.click_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create click" do
    test "renders click when data is valid", %{conn: conn} do
      conn = post(conn, Routes.click_path(conn, :create), click: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.click_path(conn, :show, id))

      assert %{
               "id" => id,
               "browser_information" => "some browser_information"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.click_path(conn, :create), click: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update click" do
    setup [:create_click]

    test "renders click when data is valid", %{conn: conn, click: %Click{id: id} = click} do
      conn = put(conn, Routes.click_path(conn, :update, click), click: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.click_path(conn, :show, id))

      assert %{
               "id" => id,
               "browser_information" => "some updated browser_information"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, click: click} do
      conn = put(conn, Routes.click_path(conn, :update, click), click: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete click" do
    setup [:create_click]

    test "deletes chosen click", %{conn: conn, click: click} do
      conn = delete(conn, Routes.click_path(conn, :delete, click))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.click_path(conn, :show, click))
      end
    end
  end

  defp create_click(_) do
    click = fixture(:click)
    %{click: click}
  end
end
