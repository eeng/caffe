defmodule Caffe.Orders.Aggregates.TabTest do
  use Caffe.AggregateCase, aggregate: Caffe.Orders.Aggregates.Tab
  use Caffe.Orders.Aliases

  alias Caffe.Orders.Commands.OrderedItem

  @tab_id UUID.uuid4()

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
    @wine %OrderedItem{menu_item_id: 1, is_drink: true}
    @beer %OrderedItem{menu_item_id: 2, is_drink: true}
    @water %OrderedItem{menu_item_id: 5, is_drink: true}
    @fish %OrderedItem{menu_item_id: 3, is_drink: false}
    @burger %OrderedItem{menu_item_id: 4, is_drink: false}

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

    test "must order something" do
      assert_error(
        %TabOpened{tab_id: @tab_id},
        %PlaceOrder{tab_id: @tab_id, items: []},
        {:error, :must_order_something}
      )
    end

    test "tab should be opened before" do
      assert_error(%PlaceOrder{tab_id: 123}, {:error, :tab_not_opened})
      assert_error(%PlaceOrder{tab_id: nil}, {:error, :tab_not_opened})
    end

    # TODO can't place multiple orders?
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
end
