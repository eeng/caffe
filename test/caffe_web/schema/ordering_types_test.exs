defmodule CaffeWeb.Schema.OrderingTypesTest do
  use CaffeWeb.ConnCase

  @query """
  mutation ($items: [OrderItemInput], $notes: String) {
    placeOrder(items: $items, notes: $notes) {
      notes
      customer_id
    }
  }
  """
  describe "place_order mutation" do
    setup do
      [customer: insert!(:user, role: "customer")]
    end

    test "valid order placed by a customer", %{customer: customer} do
      wine = insert!(:drink, name: "Wine")
      fish = insert!(:food, name: "Fish")

      order = %{
        items: [
          %{menu_item_id: wine.id, quantity: 1},
          %{menu_item_id: fish.id, quantity: 2}
        ],
        notes: "well cooked"
      }

      conn = build_conn() |> auth_user(customer) |> post("/api", query: @query, variables: order)

      assert %{"data" => %{"placeOrder" => %{"notes" => "well cooked", "customer_id" => cust_id}}} =
               json_response(conn, 200)

      assert cust_id == customer.id
    end

    test "invalid order", %{customer: customer} do
      order = %{items: []}

      conn = build_conn() |> auth_user(customer) |> post("/api", query: @query, variables: order)

      assert %{
               "errors" => [
                 %{"message" => "validation_error", "details" => %{"items" => ["can't be blank"]}}
               ]
             } = json_response(conn, 200)
    end
  end
end
