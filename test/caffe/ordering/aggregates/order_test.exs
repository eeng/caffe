defmodule Caffe.Orders.Aggregates.OrderTest do
  use Caffe.AggregateCase, aggregate: Caffe.Ordering.Aggregates.Order

  alias Caffe.Ordering.Aggregates.Order
  alias Caffe.Ordering.Commands.{PlaceOrder, OrderedItem}
  alias Caffe.Ordering.Events.OrderPlaced

  @order_id UUID.uuid4()
  @wine %OrderedItem{menu_item_id: 1, is_drink: true, price: Decimal.new(10)}

  describe "PlaceOrder command" do
    test "should emit OrderPlaced" do
      assert_events(
        %PlaceOrder{items: [@wine]},
        %OrderPlaced{
          items: [
            %{
              menu_item_id: 1,
              menu_item_name: nil,
              quantity: 1,
              status: "pending",
              price: Decimal.new(10)
            }
          ],
          order_amount: Decimal.new(10)
        }
      )
    end

    test "should calculate the total amount" do
      {_, %OrderPlaced{order_amount: total}, _} =
        execute(%Order{}, %PlaceOrder{
          items: [
            %OrderedItem{price: Decimal.new(10), quantity: 4},
            %OrderedItem{price: Decimal.new(30), quantity: 2}
          ]
        })

      assert total == Decimal.new(100)
    end

    test "can't place the same order again" do
      assert_error(
        %OrderPlaced{order_id: @order_id},
        %PlaceOrder{},
        {:error, :order_already_placed}
      )
    end
  end
end
