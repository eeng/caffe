defmodule Caffe.Orders.Aggregates.TabTest do
  use Caffe.AggregateCase, aggregate: Caffe.Orders.Aggregates.Tab
  use Caffe.Orders.Aliases

  @tab_id UUID.uuid4()

  describe "open tab" do
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

  describe "place order" do
    @wine %OrderedItem{is_drink: true}
    @beer %OrderedItem{is_drink: true}
    @fish %OrderedItem{is_drink: false}
    @burger %OrderedItem{is_drink: false}

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
          %FoodOrdered{tab_id: @tab_id, items: [@fish]},
          %DrinksOrdered{tab_id: @tab_id, items: [@wine]}
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
  end
end
