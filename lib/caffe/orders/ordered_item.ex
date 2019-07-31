defmodule Caffe.Orders.OrderedItem do
  @derive Jason.Encoder
  defstruct [:menu_item_id, :is_drink, :quantity, :price, :notes]

  # TODO how to validate this in the place order command
end
