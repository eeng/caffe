defmodule Caffe.Orders.Aggregates.TabTest do
  use Caffe.AggregateCase, aggregate: Caffe.Orders.Aggregates.Tab
  use Caffe.Orders.Aliases

  alias Caffe.Orders.Commands.OrderedItem

  @tab_id UUID.uuid4()

  @wine %OrderedItem{menu_item_id: 1, is_drink: true, price: Decimal.new(10)}
  @beer %OrderedItem{menu_item_id: 2, is_drink: true, price: Decimal.new(20)}
  @water %OrderedItem{menu_item_id: 5, is_drink: true}
  @fish %OrderedItem{menu_item_id: 3, is_drink: false}
  @burger %OrderedItem{menu_item_id: 4, is_drink: false}

  describe "OpenTab command" do
    test "should succeed when valid" do
      assert_events(
        %OpenTab{tab_id: @tab_id, table_number: 3},
        %TabOpened{tab_id: @tab_id, table_number: 3}
      )
    end

    test "can't open already opened tabs" do
      assert_error(
        %TabOpened{tab_id: @tab_id, table_number: 3},
        %OpenTab{tab_id: @tab_id},
        {:error, :tab_already_opened}
      )
    end
  end

  describe "PlaceOrder command" do
    test "when only drinks are ordered" do
      assert_events(
        %TabOpened{tab_id: @tab_id},
        %PlaceOrder{tab_id: @tab_id, items: [@wine, @beer]},
        %DrinksOrdered{tab_id: @tab_id, items: [@wine, @beer]}
      )
    end

    test "when only food is ordered" do
      assert_events(
        %TabOpened{tab_id: @tab_id},
        %PlaceOrder{tab_id: @tab_id, items: [@fish, @burger]},
        %FoodOrdered{tab_id: @tab_id, items: [@fish, @burger]}
      )
    end

    test "when drinks and food are ordered should emit two events" do
      assert_events(
        %TabOpened{tab_id: @tab_id},
        %PlaceOrder{tab_id: @tab_id, items: [@fish, @wine]},
        [
          %DrinksOrdered{tab_id: @tab_id, items: [@wine]},
          %FoodOrdered{tab_id: @tab_id, items: [@fish]}
        ]
      )
    end

    test "tab should be opened before" do
      assert_error(%PlaceOrder{tab_id: 123}, {:error, :tab_not_opened})
      assert_error(%PlaceOrder{tab_id: nil}, {:error, :tab_not_opened})
    end

    test "can't place order if tab was closed" do
      # TODO
    end
  end

  describe "MarkItemsServed command" do
    test "drinks can be served immediately" do
      assert_events(
        [
          %TabOpened{tab_id: @tab_id},
          %DrinksOrdered{tab_id: @tab_id, items: [@wine, @beer]}
        ],
        %MarkItemsServed{tab_id: @tab_id, item_ids: [@wine.menu_item_id]},
        %ItemsServed{tab_id: @tab_id, item_ids: [@wine.menu_item_id]}
      )
    end

    test "food must be prepared first" do
      assert_error(
        [
          %TabOpened{tab_id: @tab_id},
          %FoodOrdered{tab_id: @tab_id, items: [@fish]}
        ],
        %MarkItemsServed{tab_id: @tab_id, item_ids: [@fish.menu_item_id]},
        {:error, :food_must_be_prepared}
      )

      assert_events(
        [
          %TabOpened{tab_id: @tab_id},
          %FoodOrdered{tab_id: @tab_id, items: [@fish]},
          %FoodPrepared{tab_id: @tab_id, item_ids: [@fish.menu_item_id]}
        ],
        %MarkItemsServed{tab_id: @tab_id, item_ids: [@fish.menu_item_id]},
        %ItemsServed{tab_id: @tab_id, item_ids: [@fish.menu_item_id]}
      )
    end

    test "can't serve an item not ordered" do
      assert_error(
        [
          %TabOpened{tab_id: @tab_id},
          %DrinksOrdered{tab_id: @tab_id, items: [@wine, @water]}
        ],
        %MarkItemsServed{tab_id: @tab_id, item_ids: [@wine.menu_item_id, @beer.menu_item_id]},
        {:error, :item_not_ordered}
      )
    end

    test "can't serve an item twice" do
      given = [
        %TabOpened{tab_id: @tab_id},
        %DrinksOrdered{tab_id: @tab_id, items: [@wine, @beer]},
        %ItemsServed{tab_id: @tab_id, item_ids: [@wine.menu_item_id]}
      ]

      assert_error(
        given,
        %MarkItemsServed{tab_id: @tab_id, item_ids: [@wine.menu_item_id]},
        {:error, :item_already_served}
      )

      assert_events(
        given,
        %MarkItemsServed{tab_id: @tab_id, item_ids: [@beer.menu_item_id]},
        %ItemsServed{tab_id: @tab_id, item_ids: [@beer.menu_item_id]}
      )
    end
  end

  describe "BeginFoodPreparation comman" do
    test "pending food can be prepared" do
      assert_events(
        [
          %TabOpened{tab_id: @tab_id},
          %FoodOrdered{tab_id: @tab_id, items: [@fish, @burger]}
        ],
        %BeginFoodPreparation{tab_id: @tab_id, item_ids: [@fish.menu_item_id]},
        %FoodBeingPrepared{tab_id: @tab_id, item_ids: [@fish.menu_item_id]}
      )
    end

    test "can't prepare if its already being prepared" do
      assert_error(
        [
          %TabOpened{tab_id: @tab_id},
          %FoodOrdered{tab_id: @tab_id, items: [@fish, @burger]},
          %FoodBeingPrepared{tab_id: @tab_id, item_ids: [@fish.menu_item_id]}
        ],
        %BeginFoodPreparation{tab_id: @tab_id, item_ids: [@fish.menu_item_id]},
        {:error, :item_already_prepared}
      )
    end

    test "can't prepare if its already prepared" do
      assert_error(
        [
          %TabOpened{tab_id: @tab_id},
          %FoodOrdered{tab_id: @tab_id, items: [@fish]},
          %FoodBeingPrepared{tab_id: @tab_id, item_ids: [@fish.menu_item_id]},
          %FoodPrepared{tab_id: @tab_id, item_ids: [@fish.menu_item_id]}
        ],
        %BeginFoodPreparation{tab_id: @tab_id, item_ids: [@fish.menu_item_id]},
        {:error, :item_already_prepared}
      )
    end

    test "drinks don't need preparation" do
      assert_error(
        [
          %TabOpened{tab_id: @tab_id},
          %DrinksOrdered{tab_id: @tab_id, items: [@wine]}
        ],
        %BeginFoodPreparation{tab_id: @tab_id, item_ids: [@wine.menu_item_id]},
        {:error, :drinks_dont_need_preparation}
      )
    end

    test "can't prepare food not ordered" do
      assert_error(
        [%TabOpened{tab_id: @tab_id}],
        %BeginFoodPreparation{tab_id: @tab_id, item_ids: [@fish.menu_item_id]},
        {:error, :item_not_ordered}
      )
    end
  end

  describe "MarkFoodPrepared command" do
    test "food being prepared can be marked" do
      given = [
        %TabOpened{tab_id: @tab_id},
        %FoodOrdered{tab_id: @tab_id, items: [@fish, @burger]},
        %FoodBeingPrepared{tab_id: @tab_id, item_ids: [@fish.menu_item_id]}
      ]

      assert_events(
        given,
        %MarkFoodPrepared{tab_id: @tab_id, item_ids: [@fish.menu_item_id]},
        %FoodPrepared{tab_id: @tab_id, item_ids: [@fish.menu_item_id]}
      )

      assert_error(
        given,
        %MarkFoodPrepared{tab_id: @tab_id, item_ids: [@burger.menu_item_id]},
        {:error, :must_begin_preparation_beforehand}
      )
    end

    test "can't mark food not ordered" do
      assert_error(
        [%TabOpened{tab_id: @tab_id}],
        %MarkFoodPrepared{tab_id: @tab_id, item_ids: [@fish.menu_item_id]},
        {:error, :item_not_ordered}
      )
    end

    test "can't mark food already prepared" do
      assert_error(
        [
          %TabOpened{tab_id: @tab_id},
          %FoodOrdered{tab_id: @tab_id, items: [@fish]},
          %FoodPrepared{tab_id: @tab_id, item_ids: [@fish.menu_item_id]}
        ],
        %MarkFoodPrepared{tab_id: @tab_id, item_ids: [@fish.menu_item_id]},
        {:error, :item_already_prepared}
      )
    end
  end

  describe "CloseTab command" do
    test "when the whole order is paid and a tip is provided" do
      order_amount = Decimal.add(@wine.price, @beer.price)

      assert_events(
        [
          %TabOpened{tab_id: @tab_id},
          %FoodOrdered{tab_id: @tab_id, items: [@wine, @beer]},
          %ItemsServed{tab_id: @tab_id, item_ids: [@wine.menu_item_id, @beer.menu_item_id]}
        ],
        %CloseTab{tab_id: @tab_id, amount_paid: Decimal.add(order_amount, 3)},
        %TabClosed{
          tab_id: @tab_id,
          amount_paid: Decimal.add(order_amount, 3),
          order_amount: order_amount,
          tip_amount: Decimal.new(3)
        }
      )
    end

    test "must pay at least the served value" do
      given = [
        %TabOpened{tab_id: @tab_id},
        %FoodOrdered{tab_id: @tab_id, items: [@wine, @beer]},
        %ItemsServed{tab_id: @tab_id, item_ids: [@wine.menu_item_id]}
      ]

      assert_error(
        given,
        %CloseTab{tab_id: @tab_id, amount_paid: Decimal.sub(@wine.price, Decimal.new(1))},
        {:error, :must_pay_enough}
      )

      assert_events(
        given,
        %CloseTab{tab_id: @tab_id, amount_paid: @wine.price},
        %TabClosed{
          tab_id: @tab_id,
          amount_paid: @wine.price,
          order_amount: @wine.price,
          tip_amount: Decimal.new(0)
        }
      )
    end

    test "can't pay if there is nothing to pay" do
      assert_error(
        [
          %TabOpened{tab_id: @tab_id},
          %DrinksOrdered{tab_id: @tab_id, items: [@wine]}
        ],
        %CloseTab{tab_id: @tab_id, amount_paid: @wine.price},
        {:error, :nothing_to_pay}
      )
    end

    test "can't pay if already payed" do
      assert_error(
        [
          %TabOpened{tab_id: @tab_id},
          %DrinksOrdered{tab_id: @tab_id, items: [@wine]},
          %ItemsServed{tab_id: @tab_id, item_ids: [@wine.menu_item_id]},
          %TabClosed{tab_id: @tab_id}
        ],
        %CloseTab{tab_id: @tab_id, amount_paid: @wine.price},
        {:error, :already_closed}
      )
    end
  end
end
