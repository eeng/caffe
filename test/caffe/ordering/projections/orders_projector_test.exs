defmodule Caffe.Ordering.Projections.OrdersProjectorTest do
  use Caffe.ProjectorCase, projector: Caffe.Ordering.Projections.OrdersProjector, async: true

  alias Caffe.Ordering.Events.{ItemsServed, OrderPaid}
  alias Caffe.Ordering.Projections.{Order, Item}

  test "ItemsServed event should change the serve tab item status of that order" do
    %{id: order1} = insert!(:order, items: [%{menu_item_id: 1}, %{menu_item_id: 2}])
    %{id: order2} = insert!(:order, items: [%{menu_item_id: 1}, %{menu_item_id: 2}])

    assert :ok = handle_event(%ItemsServed{order_id: order1, item_ids: [2]})

    assert ["pending", "served"] == item_statuses_of_order(order1)
    assert ["pending", "pending"] == item_statuses_of_order(order2)
  end

  test "OrderPaid should update the tab status and amounts" do
    %{id: order_id} = insert!(:order)

    assert :ok =
             handle_event(%OrderPaid{
               order_id: order_id,
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
             Repo.get(Order, order_id)
             |> Map.take(~w[status amount_paid order_amount tip_amount]a)
  end

  def item_statuses_of_order(order_id) do
    from(i in Item,
      select: i.status,
      where: i.order_id == ^order_id,
      order_by: i.menu_item_id
    )
    |> Repo.all()
  end
end