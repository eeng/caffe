defmodule Caffe.Orders.Aliases do
  defmacro __using__(_) do
    quote do
      alias Caffe.Orders.Aggregates.Tab
      alias Caffe.Orders.Commands.{OpenTab, PlaceOrder, MarkItemsServed}
      alias Caffe.Orders.Events.{TabOpened, DrinksOrdered, FoodOrdered, ItemsServed}
    end
  end
end
