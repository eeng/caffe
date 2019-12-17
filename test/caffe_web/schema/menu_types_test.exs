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

  describe "saveMenuItem mutation" do
    setup do
      [deserts: insert!(:category, name: "Deserts")]
    end

    @query """
    mutation ($menuItem: MenuItemInput!) {
      saveMenuItem(input: $menuItem) {
        name
        price
      }
    }
    """
    test "creating with valid data", %{deserts: deserts} do
      menu_item = %{
        "name" => "Ice Cream",
        "price" => "10.99",
        "categoryId" => deserts.id
      }

      conn = build_conn() |> post("/api", query: @query, variables: %{"menuItem" => menu_item})

      assert json_response(conn, 200) == %{
               "data" => %{
                 "saveMenuItem" => %{
                   "name" => menu_item["name"],
                   "price" => menu_item["price"]
                 }
               }
             }
    end

    test "creating with invalid data", %{deserts: deserts} do
      menu_item = %{
        "name" => "",
        "price" => "10.99",
        "categoryId" => deserts.id
      }

      conn = build_conn() |> post("/api", query: @query, variables: %{"menuItem" => menu_item})

      assert %{
               "errors" => [
                 %{"details" => %{"name" => ["can't be blank"]}}
               ]
             } = json_response(conn, 200)

      menu_item = %{"price" => 456}
      conn = build_conn() |> post("/api", query: @query, variables: %{"menuItem" => menu_item})
      assert %{"errors" => [_]} = json_response(conn, 200)
    end

    test "updating with valid data", %{deserts: deserts} do
      fries = insert!(:menu_item, name: "Fries")

      menu_item = %{
        "id" => to_string(fries.id),
        "name" => "French Fries",
        # TODO should not be necesary
        "price" => "10.99",
        # TODO should not be necesary
        "categoryId" => deserts.id
      }

      conn = build_conn() |> post("/api", query: @query, variables: %{"menuItem" => menu_item})

      assert %{
               "data" => %{
                 "saveMenuItem" => %{
                   "name" => "French Fries"
                 }
               }
             } = json_response(conn, 200)

      assert Menu.Item |> Repo.all() |> length == 1
    end

    test "updating non-existant item" do
      menu_item = %{
        "id" => "0",
        # TODO should not be necesary
        "name" => "French Fries",
        "price" => "10.99",
        "categoryId" => 1
      }

      conn = build_conn() |> post("/api", query: @query, variables: %{"menuItem" => menu_item})

      assert %{
               "data" => %{"saveMenuItem" => nil},
               "errors" => [%{"message" => "Menu item not found"}]
             } = json_response(conn, 200)
    end
  end

  @query """
  mutation ($id: ID) {
    deleteMenuItem(id: $id)
  }
  """
  test "deleteMenuItem mutation" do
    cheese = insert!(:menu_item, name: "Cheese")

    conn = build_conn() |> post("/api", query: @query, variables: %{"id" => cheese.id})
    assert json_response(conn, 200) == %{"data" => %{"deleteMenuItem" => true}}

    assert Menu.Item |> Repo.all() == []

    conn = build_conn() |> post("/api", query: @query, variables: %{"id" => 456})

    assert %{
             "data" => %{"deleteMenuItem" => nil},
             "errors" => [%{"message" => "Menu item not found"}]
           } = json_response(conn, 200)
  end
end
