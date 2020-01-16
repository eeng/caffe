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
    OrderPaid,
    OrderCancelled
  }

  project %OrderPlaced{order_id: order_id} = evt, %{created_at: created_at}, fn multi ->
    changeset =
      Order.changeset(%Order{id: order_id, order_date: created_at}, Map.from_struct(evt))

    Multi.insert(multi, :insert, changeset)
  end

  project %ItemsServed{} = evt, fn multi ->
    update_items_state(multi, evt, "served")
  end

  project %FoodBeingPrepared{} = evt, fn multi ->
    update_items_state(multi, evt, "preparing")
  end

  project %FoodPrepared{} = evt, fn multi ->
    update_items_state(multi, evt, "prepared")
  end

  project %OrderPaid{order_id: order_id} = evt, fn multi ->
    changeset =
      Order
      |> Repo.get(order_id)
      |> Order.changeset(%{
        state: "paid",
        amount_paid: evt.amount_paid,
        order_amount: evt.order_amount,
        tip_amount: evt.tip_amount
      })

    Multi.update(multi, :update, changeset)
  end

  project %OrderCancelled{order_id: order_id}, fn multi ->
    query = from o in Order, where: o.id == ^order_id
    Multi.update_all(multi, :update, query, set: [state: "cancelled"])
  end

  defp update_items_state(multi, %{order_id: order_id, item_ids: item_ids}, state) do
    query = from i in Item, where: i.order_id == ^order_id and i.menu_item_id in ^item_ids
    Multi.update_all(multi, :update, query, set: [state: state])
  end
end
