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
  end

  @query """
  mutation ($orderId: ID, $itemIds: [ID!]!) {
    markItemsServed(orderId: $orderId, itemIds: $itemIds)
  }
  """
  describe "mark_items_served mutation" do
    test "valid case" do
      cust = insert!(:customer)
      waiter = insert!(:waitstaff)
      wine = insert!(:drink)
      %{id: order_id} = place_order_as(cust, %{items: [%{menu_item_id: wine.id}]})

      conn =
        build_conn(waiter)
        |> post("/api", query: @query, variables: %{orderId: order_id, itemIds: [wine.id]})

      assert %{"data" => %{"markItemsServed" => "ok"}} = json_response(conn, 200)
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
  end

  defp place_order_as(user, order_args \\ %{items: [%{menu_item_id: insert!(:drink).id}]}) do
    {:ok, order} = Ordering.place_order(order_args, user)
    order
  end

  @query """
  query ($id: ID) {
    order(id: $id) {
      notes
    }
  }
  """
  describe "order query" do
    test "when it exists" do
      order = insert!(:order, notes: "...")
      user = insert!(:admin)
      conn = build_conn(user) |> post("/api", query: @query, variables: %{id: order.id})
      assert %{"data" => %{"order" => %{"notes" => "..."}}} = json_response(conn, 200)
    end

    test "when it doesn't exists" do
      insert!(:order)
      user = insert!(:admin)
      conn = build_conn(user) |> post("/api", query: @query, variables: %{id: "nop"})
      assert %{"errors" => [%{"message" => "not_found"}]} = json_response(conn, 200)
    end

    test "customers can only view their orders" do
      [cust1, cust2] = insert!(2, :customer)
      order = insert!(:order, customer_id: cust1.id)

      conn = build_conn(cust1) |> post("/api", query: @query, variables: %{id: order.id})
      assert %{"data" => %{"order" => %{}}} = json_response(conn, 200)

      conn = build_conn(cust2) |> post("/api", query: @query, variables: %{id: order.id})
      assert %{"errors" => [%{"message" => "unauthorized"}]} = json_response(conn, 200)
    end

    @query """
    query ($id: ID) {
      order(id: $id) {
        viewerCanCancel
      }
    }
    """
    test "the viewer can check if she can cancel the order" do
      cust = insert!(:customer)
      order1 = insert!(:order, state: "pending", customer_id: cust.id)
      order2 = insert!(:order, state: "cancelled", customer_id: cust.id)

      conn = build_conn(cust) |> post("/api", query: @query, variables: %{id: order1.id})
      assert %{"data" => %{"order" => %{"viewerCanCancel" => true}}} = json_response(conn, 200)

      conn = build_conn(cust) |> post("/api", query: @query, variables: %{id: order2.id})
      assert %{"data" => %{"order" => %{"viewerCanCancel" => false}}} = json_response(conn, 200)
    end
  end
end
