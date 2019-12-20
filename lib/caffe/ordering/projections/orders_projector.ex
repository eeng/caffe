defmodule Caffe.Ordering.Projections.OrdersProjector do
  use Commanded.Projections.Ecto,
    name: "Ordering.Projections.OrdersProjector",
    consistency: :strong

  require Logger
  alias Ecto.Multi
  alias Caffe.Ordering.Projections.Order

  alias Caffe.Ordering.Events.{
    OrderPlaced
  }

  project %OrderPlaced{order_id: order_id} = command, fn multi ->
    changeset = Order.changeset(%Order{id: order_id}, Map.from_struct(command))
    Multi.insert(multi, :insert, changeset)
  end
end
