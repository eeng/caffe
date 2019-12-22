defmodule CaffeWeb.Schema.MenuTypesTest do
  use CaffeWeb.ConnCase, async: true

  alias Caffe.Menu

  @query """
  {
    menuItems {
      name
      category { name }
    }
  }
  """
  test "menuItems query" do
    insert!(:menu_item, name: "Big Mac", category: build(:category, name: "Hamburgers"))
    conn = build_conn() |> get("/api", query: @query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "menuItems" => [
                 %{
                   "name" => "Big Mac",
                   "category" => %{"name" => "Hamburgers"}
                 }
               ]
             }
           }
  end

  @query """
  {
    categories {
      name
      items { name }
    }
  }
  """
  test "categories query" do
    desserts = insert!(:category, name: "desserts")
    insert!(:menu_item, name: "Tiramisu", category: desserts)

    salads = insert!(:category, name: "Salads")
    insert!(:menu_item, name: "Ceasar", category: salads)

    conn = build_conn() |> get("/api", query: @query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "categories" => [
                 %{
                   "name" => "desserts",
                   "items" => [%{"name" => "Tiramisu"}]
                 },
                 %{
                   "name" => "Salads",
                   "items" => [%{"name" => "Ceasar"}]
                 }
               ]
             }
           }
  end

  @query """
  mutation ($name: String, $price: Decimal, $categoryId: Int) {
    createMenuItem(name: $name, price: $price, categoryId: $categoryId) {
      name
      price
    }
  }
  """
  describe "createMenuItem mutation" do
    setup do
      [
        desserts: insert!(:category, name: "desserts"),
        conn: build_conn() |> auth_user(insert!(:admin))
      ]
    end

    test "valid data", %{conn: conn, desserts: desserts} do
      menu_item = %{
        "name" => "Ice Cream",
        "price" => "10.99",
        "categoryId" => desserts.id
      }

      conn = post(conn, "/api", query: @query, variables: menu_item)

      assert json_response(conn, 200) == %{
               "data" => %{
                 "createMenuItem" => %{
                   "name" => "Ice Cream",
                   "price" => "10.99"
                 }
               }
             }
    end

    test "invalid data", %{conn: conn, desserts: desserts} do
      menu_item = %{
        "name" => "",
        "price" => "10.99",
        "categoryId" => desserts.id
      }

      conn = post(conn, "/api", query: @query, variables: menu_item)

      assert %{
               "errors" => [
                 %{"message" => "validation_error", "details" => %{"name" => ["can't be blank"]}}
               ]
             } = json_response(conn, 200)

      menu_item = %{menu_item | "price" => 456}
      conn = build_conn() |> post("/api", query: @query, variables: menu_item)
      assert %{"errors" => [_]} = json_response(conn, 200)
    end

    test "only admins can create items", %{desserts: desserts} do
      menu_item = %{
        "name" => "Ice Cream",
        "price" => "10.99",
        "categoryId" => desserts.id
      }

      conn = build_conn() |> post("/api", query: @query, variables: menu_item)
      assert %{"errors" => [%{"message" => "unauthorized"}]} = json_response(conn, 200)
    end
  end

  describe "updateMenuItem mutation" do
    setup do
      [conn: build_conn() |> auth_user(insert!(:admin))]
    end

    @query """
    mutation ($id: ID, $name: String, $price: Decimal) {
      updateMenuItem(id: $id, name: $name, price: $price) { name, price }
    }
    """
    test "valid data", %{conn: conn} do
      fries = insert!(:menu_item, name: "Fries", price: 9.99)

      menu_item = %{
        "id" => to_string(fries.id),
        "name" => "French Fries",
        "price" => "10.99"
      }

      conn = post(conn, "/api", query: @query, variables: menu_item)

      assert %{
               "data" => %{
                 "updateMenuItem" => %{
                   "name" => "French Fries",
                   "price" => "10.99"
                 }
               }
             } = json_response(conn, 200)

      assert Menu.Item |> Repo.all() |> length == 1
    end

    @query """
    mutation ($id: ID) {
      updateMenuItem(id: $id) { name }
    }
    """
    test "non-existant item", %{conn: conn} do
      menu_item = %{"id" => "0"}
      conn = post(conn, "/api", query: @query, variables: menu_item)

      assert %{
               "data" => %{"updateMenuItem" => nil},
               "errors" => [%{"message" => "not_found"}]
             } = json_response(conn, 200)
    end
  end

  @query """
  mutation ($id: ID) {
    deleteMenuItem(id: $id) { id }
  }
  """
  describe "deleteMenuItem mutation" do
    setup do
      [conn: build_conn() |> auth_user(insert!(:admin))]
    end

    test "existing menu item", %{conn: conn} do
      cheese = insert!(:menu_item, name: "Cheese")

      conn = post(conn, "/api", query: @query, variables: %{"id" => cheese.id})

      assert json_response(conn, 200) == %{
               "data" => %{"deleteMenuItem" => %{"id" => to_string(cheese.id)}}
             }

      assert Menu.Item |> Repo.all() == []
    end

    test "non-existing menu item", %{conn: conn} do
      conn = post(conn, "/api", query: @query, variables: %{"id" => 456})

      assert %{
               "data" => %{"deleteMenuItem" => nil},
               "errors" => [%{"message" => "not_found"}]
             } = json_response(conn, 200)
    end
  end
end
