defmodule Caffe.Orders.Projections.TabsProjectorTest do
  use Caffe.ProjectorCase, projector: Caffe.Orders.Projections.TabsProjector, async: true

  alias Caffe.Orders.Events.{ItemsServed, DrinksOrdered, TabClosed}
  alias Caffe.Orders.Projections.{Tab, TabItem}

  test "DrinksOrdered event should insert the items for the tab" do
    %{id: tab1} = insert!(:tab)
    %{id: tab2} = insert!(:tab)

    assert :ok = handle_event(%DrinksOrdered{tab_id: tab1, items: [params_for(:tab_item)]})

    assert ["pending"] == item_statuses_of_tab(tab1)
    assert [] == item_statuses_of_tab(tab2)
  end

  test "ItemsServed event should change served tab item status" do
    %{id: tab1} = insert!(:tab, items: [%{menu_item_id: 1}, %{menu_item_id: 2}])
    %{id: tab2} = insert!(:tab, items: [%{menu_item_id: 1}, %{menu_item_id: 2}])

    assert :ok = handle_event(%ItemsServed{tab_id: tab1, item_ids: [2]})

    assert ["pending", "served"] == item_statuses_of_tab(tab1)
    assert ["pending", "pending"] == item_statuses_of_tab(tab2)
  end

  test "TabClosed should update the tab status and amounts" do
    %{id: tab_id} = insert!(:tab)

    assert :ok =
             handle_event(%TabClosed{
               tab_id: tab_id,
               amount_paid: 10,
               order_amount: 7,
               tip_amount: 3
             })

    assert %{
             status: "closed",
             amount_paid: Decimal.new(10),
             order_amount: Decimal.new(7),
             tip_amount: Decimal.new(3)
           } ==
             Tab |> Repo.get(tab_id) |> Map.take(~w[status amount_paid order_amount tip_amount]a)
  end

  def item_statuses_of_tab(tab_id) do
    from(i in TabItem, select: i.status, where: i.tab_id == ^tab_id, order_by: i.menu_item_id)
    |> Repo.all()
  end
end
