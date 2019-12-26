defmodule CaffeWeb.Schema.OrderingTypesTest do
  use CaffeWeb.ConnCase
  use Caffe.EventStoreCase

  alias Caffe.Ordering

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
      [customer: insert!(:customer)]
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

      conn = build_conn(customer) |> post("/api", query: @query, variables: order)

      assert %{"data" => %{"placeOrder" => %{"notes" => "well cooked", "customer_id" => cust_id}}} =
               json_response(conn, 200)

      assert cust_id == customer.id
    end

    test "invalid order", %{customer: customer} do
      order = %{items: []}

      conn = build_conn(customer) |> post("/api", query: @query, variables: order)

      assert %{
               "errors" => [
                 %{"message" => "validation_error", "details" => %{"items" => ["can't be blank"]}}
               ]
             } = json_response(conn, 200)
    end

    test "the user must be authenticated" do
      order = %{items: [%{menu_item_id: insert!(:drink).id, quantity: 1}]}
      conn = build_conn() |> post("/api", query: @query, variables: order)
      assert %{"errors" => [%{"message" => "unauthorized"}]} = json_response(conn, 200)
    end
  end

  @query """
  mutation ($orderId: ID) {
    cancelOrder(orderId: $orderId)
  }
  """
  describe "cancel_order mutation" do
    test "valid case" do
      user = insert!(:customer)
      %{id: order_id} = place_order_as(user)

      conn = build_conn(user) |> post("/api", query: @query, variables: %{orderId: order_id})
      assert %{"data" => %{"cancelOrder" => "ok"}} = json_response(conn, 200)
    end

    test "the user should be authorized" do
      [cust1, cust2] = insert!(2, :customer)
      %{id: order_id} = place_order_as(cust1)

      conn = build_conn(cust2) |> post("/api", query: @query, variables: %{orderId: order_id})
      assert %{"errors" => [%{"message" => "unauthorized"}]} = json_response(conn, 200)
    end

    defp place_order_as(user) do
      {:ok, order} = Ordering.place_order(%{items: [%{menu_item_id: insert!(:drink).id}]}, user)
      order
    end
  end
end
