defmodule Caffe.Ordering.Aggregates.Order do
  defstruct [:id, items: []]

  alias Caffe.Ordering.Aggregates.Order
  alias Caffe.Ordering.Commands.{PlaceOrder}
  alias Caffe.Ordering.Events.{OrderPlaced}

  def execute(%Order{id: nil}, %PlaceOrder{} = command) do
    struct(OrderPlaced, Map.from_struct(command))
  end

  def apply(%Order{}, %OrderPlaced{order_id: id, items: items}) do
    %Order{id: id, items: items}
  end
end
