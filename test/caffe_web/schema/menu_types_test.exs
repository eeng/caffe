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
    deserts = insert!(:category, name: "Deserts")
    insert!(:menu_item, name: "Tiramisu", category: deserts)

    salads = insert!(:category, name: "Salads")
    insert!(:menu_item, name: "Ceasar", category: salads)

    conn = build_conn() |> get("/api", query: @query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "categories" => [
                 %{
                   "name" => "Deserts",
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

  describe "createMenuItem mutation" do
    setup do
      [deserts: insert!(:category, name: "Deserts")]
    end

    @query """
    mutation ($name: String, $price: Decimal, $categoryId: Int) {
      createMenuItem(name: $name, price: $price, categoryId: $categoryId) {
        name
        price
      }
    }
    """
    test "valid data", %{deserts: deserts} do
      menu_item = %{
        "name" => "Ice Cream",
        "price" => "10.99",
        "categoryId" => deserts.id
      }

      conn = build_conn() |> post("/api", query: @query, variables: menu_item)

      assert json_response(conn, 200) == %{
               "data" => %{
                 "createMenuItem" => %{
                   "name" => "Ice Cream",
                   "price" => "10.99"
                 }
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
    test "invalid data", %{deserts: deserts} do
      menu_item = %{
        "name" => "",
        "price" => "10.99",
        "categoryId" => deserts.id
      }

      conn = build_conn() |> post("/api", query: @query, variables: menu_item)

      assert %{
               "errors" => [
                 %{"message" => "validation_error", "details" => %{"name" => ["can't be blank"]}}
               ]
             } = json_response(conn, 200)

      menu_item = %{menu_item | "price" => 456}
      conn = build_conn() |> post("/api", query: @query, variables: menu_item)
      assert %{"errors" => [_]} = json_response(conn, 200)
    end
  end

  describe "updateMenuItem mutation" do
    @query """
    mutation ($id: ID, $name: String, $price: Decimal) {
      updateMenuItem(id: $id, name: $name, price: $price) { name, price }
    }
    """
    test "valid data" do
      fries = insert!(:menu_item, name: "Fries", price: 9.99)

      menu_item = %{
        "id" => to_string(fries.id),
        "name" => "French Fries",
        "price" => "10.99"
      }

      conn = build_conn() |> post("/api", query: @query, variables: menu_item)

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
    test "non-existant item" do
      menu_item = %{"id" => "0"}
      conn = build_conn() |> post("/api", query: @query, variables: menu_item)

      assert %{
               "data" => %{"updateMenuItem" => nil},
               "errors" => [%{"message" => "not_found"}]
             } = json_response(conn, 200)
    end
  end

  describe "deleteMenuItem mutation" do
    @query """
    mutation ($id: ID) {
      deleteMenuItem(id: $id) { id }
    }
    """
    test "existing menu item" do
      cheese = insert!(:menu_item, name: "Cheese")

      conn = build_conn() |> post("/api", query: @query, variables: %{"id" => cheese.id})

      assert json_response(conn, 200) == %{
               "data" => %{"deleteMenuItem" => %{"id" => to_string(cheese.id)}}
             }

      assert Menu.Item |> Repo.all() == []
    end

    test "non-existing menu item" do
      conn = build_conn() |> post("/api", query: @query, variables: %{"id" => 456})

      assert %{
               "data" => %{"deleteMenuItem" => nil},
               "errors" => [%{"message" => "not_found"}]
             } = json_response(conn, 200)
    end
  end
end
