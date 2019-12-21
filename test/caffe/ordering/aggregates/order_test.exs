defmodule Caffe.Orders.Aggregates.OrderTest do
  use Caffe.AggregateCase, aggregate: Caffe.Ordering.Aggregates.Order

  alias Caffe.Ordering.Aggregates.Order

  alias Caffe.Ordering.Commands.{
    PlaceOrder,
    OrderedItem,
    BeginFoodPreparation,
    MarkFoodPrepared,
    MarkItemsServed,
    PayOrder
  }

  alias Caffe.Ordering.Events.{
    OrderPlaced,
    ItemsServed,
    FoodBeingPrepared,
    FoodPrepared,
    OrderPaid
  }

  @order_id UUID.uuid4()

  setup do
    [
      wine: %{menu_item_id: 1, is_drink: true, status: "pending", price: Decimal.new(10)},
      beer: %{menu_item_id: 2, is_drink: true, status: "pending", price: Decimal.new(20)},
      fish: %{menu_item_id: 5, is_drink: false, status: "pending"},
      burger: %{menu_item_id: 6, is_drink: false, status: "pending"}
    ]
  end

  describe "PlaceOrder command" do
    test "should emit OrderPlaced" do
      wine = %OrderedItem{menu_item_id: 1, is_drink: true, price: Decimal.new(10)}

      assert_result(
        %PlaceOrder{items: [wine]},
        %OrderPlaced{
          items: [
            %{
              menu_item_id: 1,
              menu_item_name: nil,
              quantity: 1,
              is_drink: true,
              status: "pending",
              price: Decimal.new(10)
            }
          ],
          order_amount: Decimal.new(10)
        }
      )
    end

    test "should calculate the total amount" do
      {_, %OrderPlaced{order_amount: total}} =
        execute2(%Order{}, %PlaceOrder{
          items: [
            %OrderedItem{price: Decimal.new(10), quantity: 4},
            %OrderedItem{price: Decimal.new(30), quantity: 2}
          ]
        })

      assert total == Decimal.new(100)
    end

    test "can't place the same order again" do
      assert_result(
        %OrderPlaced{order_id: @order_id},
        %PlaceOrder{},
        {:error, :order_already_placed}
      )
    end
  end

  describe "MarkItemsServed command" do
    test "drinks can be served immediately", %{wine: wine, beer: beer} do
      assert_result(
        %OrderPlaced{order_id: @order_id, items: [wine, beer]},
        %MarkItemsServed{order_id: @order_id, item_ids: [wine.menu_item_id]},
        %ItemsServed{order_id: @order_id, item_ids: [wine.menu_item_id]}
      )
    end

    test "food must be prepared first", %{fish: fish} do
      assert_result(
        %OrderPlaced{order_id: @order_id, items: [fish]},
        %MarkItemsServed{order_id: @order_id, item_ids: [fish.menu_item_id]},
        {:error, :food_must_be_prepared}
      )

      assert_result(
        [
          %OrderPlaced{order_id: @order_id, items: [fish]},
          %FoodPrepared{order_id: @order_id, item_ids: [fish.menu_item_id]}
        ],
        %MarkItemsServed{order_id: @order_id, item_ids: [fish.menu_item_id]},
        %ItemsServed{order_id: @order_id, item_ids: [fish.menu_item_id]}
      )
    end

    test "can't serve an item not ordered", %{wine: wine, beer: beer} do
      water = %{menu_item_id: 9, is_drink: true, status: "pending"}

      assert_result(
        %OrderPlaced{order_id: @order_id, items: [wine, water]},
        %MarkItemsServed{order_id: @order_id, item_ids: [wine.menu_item_id, beer.menu_item_id]},
        {:error, :item_not_ordered}
      )
    end

    test "can't serve an item twice", %{wine: wine} do
      assert_result(
        [
          %OrderPlaced{order_id: @order_id, items: [wine]},
          %ItemsServed{order_id: @order_id, item_ids: [wine.menu_item_id]}
        ],
        %MarkItemsServed{order_id: @order_id, item_ids: [wine.menu_item_id]},
        {:error, :item_already_served}
      )
    end
  end

  describe "BeginFoodPreparation command" do
    test "pending food can be prepared", %{fish: fish} do
      assert_result(
        %OrderPlaced{order_id: @order_id, items: [fish]},
        %BeginFoodPreparation{order_id: @order_id, item_ids: [fish.menu_item_id]},
        %FoodBeingPrepared{order_id: @order_id, item_ids: [fish.menu_item_id]}
      )
    end

    test "can't prepare if its already being prepared", %{fish: fish} do
      assert_result(
        [
          %OrderPlaced{order_id: @order_id, items: [fish]},
          %FoodBeingPrepared{order_id: @order_id, item_ids: [fish.menu_item_id]}
        ],
        %BeginFoodPreparation{order_id: @order_id, item_ids: [fish.menu_item_id]},
        {:error, :item_already_prepared}
      )
    end

    test "drinks don't need preparation", %{wine: wine} do
      assert_result(
        %OrderPlaced{order_id: @order_id, items: [wine]},
        %BeginFoodPreparation{order_id: @order_id, item_ids: [wine.menu_item_id]},
        {:error, :drinks_dont_need_preparation}
      )
    end
  end

  describe "MarkFoodPrepared command" do
    test "food being prepared can be marked", %{fish: fish} do
      assert_result(
        [
          %OrderPlaced{order_id: @order_id, items: [fish]},
          %FoodBeingPrepared{order_id: @order_id, item_ids: [fish.menu_item_id]}
        ],
        %MarkFoodPrepared{order_id: @order_id, item_ids: [fish.menu_item_id]},
        %FoodPrepared{order_id: @order_id, item_ids: [fish.menu_item_id]}
      )
    end

    test "also food pending can be marked", %{fish: fish} do
      assert_result(
        %OrderPlaced{order_id: @order_id, items: [fish]},
        %MarkFoodPrepared{order_id: @order_id, item_ids: [fish.menu_item_id]},
        %FoodPrepared{order_id: @order_id, item_ids: [fish.menu_item_id]}
      )
    end

    test "can't mark food not ordered", %{fish: fish, burger: burger} do
      assert_error(
        %OrderPlaced{order_id: @order_id, items: [fish]},
        %MarkFoodPrepared{order_id: @order_id, item_ids: [burger.menu_item_id]},
        {:error, :item_not_ordered}
      )
    end
  end

  describe "PayOrder command" do
    test "when the whole order is paid and a tip is provided", %{wine: wine, beer: beer} do
      order_amount = Decimal.add(wine.price, beer.price)

      assert_result(
        %OrderPlaced{order_id: @order_id, items: [wine, beer], order_amount: order_amount},
        %PayOrder{order_id: @order_id, amount_paid: Decimal.add(order_amount, 3)},
        %OrderPaid{
          order_id: @order_id,
          amount_paid: Decimal.add(order_amount, 3),
          order_amount: order_amount,
          tip_amount: Decimal.new(3)
        }
      )
    end

    test "must pay at least the order amount", %{wine: wine} do
      assert_result(
        %OrderPlaced{order_id: @order_id, items: [wine], order_amount: wine.price},
        %PayOrder{order_id: @order_id, amount_paid: Decimal.sub(wine.price, 1)},
        {:error, :must_pay_enough}
      )
    end

    test "can't pay again", %{wine: wine} do
      assert_result(
        [
          %OrderPlaced{order_id: @order_id, items: [wine], order_amount: wine.price},
          %OrderPaid{order_id: @order_id, amount_paid: wine.price}
        ],
        %PayOrder{order_id: @order_id, amount_paid: wine.price},
        {:error, :order_closed}
      )
    end
  end
end
