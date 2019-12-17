defmodule CaffeWeb.Schema.MenuTypesTest do
  use CaffeWeb.ConnCase, async: true

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
end
