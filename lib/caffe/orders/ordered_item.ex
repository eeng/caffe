defmodule Caffe.Orders.OrderedItem do
  @derive Jason.Encoder
  defstruct [:menu_item_id, :menu_item_name, :is_drink, :price, :notes, quantity: 1]

  # TODO how to validate this in the place order command
end
