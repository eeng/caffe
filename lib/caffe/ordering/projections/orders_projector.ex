defmodule Caffe.Ordering.Projections.OrdersProjector do
  use Commanded.Projections.Ecto,
    name: "Ordering.Projections.OrdersProjector",
    consistency: :strong

  require Logger

  alias Ecto.Multi
  alias Caffe.Repo
  alias Caffe.Ordering.Projections.{Order, Item}

  alias Caffe.Ordering.Events.{
    OrderPlaced,
    ItemsServed,
    FoodBeingPrepared,
    FoodPrepared,
    OrderPaid
  }

  project %OrderPlaced{order_id: order_id} = command, fn multi ->
    changeset = Order.changeset(%Order{id: order_id}, Map.from_struct(command))
    Multi.insert(multi, :insert, changeset)
  end

  project %ItemsServed{} = evt, fn multi ->
    update_items_statuses(multi, evt, "served")
  end

  project %FoodBeingPrepared{} = evt, fn multi ->
    update_items_statuses(multi, evt, "preparing")
  end

  project %FoodPrepared{} = evt, fn multi ->
    update_items_statuses(multi, evt, "prepared")
  end

  project %OrderPaid{order_id: order_id} = evt, fn multi ->
    changeset =
      Order
      |> Repo.get(order_id)
      |> Order.changeset(%{
        status: "closed",
        amount_paid: evt.amount_paid,
        order_amount: evt.order_amount,
        tip_amount: evt.tip_amount
      })

    Multi.update(multi, :update, changeset)
  end

  defp update_items_statuses(multi, %{order_id: order_id, item_ids: item_ids}, status) do
    query = from i in Item, where: i.order_id == ^order_id and i.menu_item_id in ^item_ids
    Multi.update_all(multi, :update, query, set: [status: status])
  end
end
