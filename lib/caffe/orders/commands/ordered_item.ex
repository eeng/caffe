defmodule Caffe.Orders.Commands.OrderedItem do
  @derive Jason.Encoder
  defstruct [:menu_item_id, :menu_item_name, :is_drink, :price, :notes, quantity: 1]

  use Caffe.Constructor

  # TODO how to validate this in the place order command
end
