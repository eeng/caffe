defmodule Caffe.Orders.OrderedItem do
  @derive Jason.Encoder
  defstruct [:menu_item_id, :is_drink, :quantity, :price, :notes]
end
