defmodule Caffe.OrdersTest do
  use Caffe.EventStoreCase

  alias Caffe.Orders
  alias Caffe.Orders.Projections.{Tab, TabItem}

  @moduletag :integration

  setup :open_tab

  test "opening a tab", %{tab_id: tab_id} do
    assert tab_id
    assert Repo.get(Tab, tab_id).table_number == 3
  end

  test "placing an order", %{tab_id: tab_id} do
    wine = insert!(:drink, name: "Wine")
    fish = insert!(:food, name: "Fish", price: 40)
    salad = insert!(:food, name: "Salad")

    :ok =
      Orders.place_order(%{
        tab_id: tab_id,
        items: [
          %{menu_item_id: wine.id, quantity: 2},
          %{menu_item_id: fish.id, notes: "ns"},
          %{menu_item_id: salad.id}
        ]
      })

    assert %Tab{items: [%TabItem{} = item1, %TabItem{} = item2, %TabItem{} = item3]} =
             Orders.get_tab(tab_id)

    assert %{menu_item_id: wine.id, menu_item_name: "Wine", quantity: 2, notes: nil} ==
             Map.take(item1, ~w[menu_item_id menu_item_name quantity notes]a)

    assert %{menu_item_id: fish.id, price: Decimal.new(40), quantity: 1, notes: "ns"} ==
             Map.take(item2, ~w[menu_item_id price quantity notes]a)
  end

  test "preparing food, serving and paying", %{tab_id: tab_id} do
    wine = insert!(:drink, name: "Wine", price: 10)
    fish = insert!(:food, name: "Fish", price: 20)

    :ok =
      Orders.place_order(%{
        tab_id: tab_id,
        items: [%{menu_item_id: wine.id}, %{menu_item_id: fish.id}]
      })

    :ok = Orders.mark_items_served(%{tab_id: tab_id, item_ids: [wine.id]})
    :ok = Orders.begin_food_preparation(%{tab_id: tab_id, item_ids: [fish.id]})
    :ok = Orders.mark_food_prepared(%{tab_id: tab_id, item_ids: [fish.id]})
    :ok = Orders.mark_items_served(%{tab_id: tab_id, item_ids: [fish.id]})

    {:error, :must_pay_enough} = Orders.close_tab(%{tab_id: tab_id, amount_paid: 29})
    :ok = Orders.close_tab(%{tab_id: tab_id, amount_paid: 30})

    assert %Tab{status: "closed"} = Repo.get(Tab, tab_id)
  end

  defp open_tab(_context) do
    {:ok, tab_id} = Orders.open_tab(%{table_number: 3})
    %{tab_id: tab_id}
  end
end
