defmodule Caffe.Orders.Commands.OrderedItem do
  @derive Jason.Encoder
  defstruct [
    :menu_item_id,
    :menu_item_name,
    :is_drink,
    :price,
    :notes,
    status: "pending",
    quantity: 1
  ]

  use Caffe.Command

  validates :quantity, number: [greater_than: 0]
  validates :notes, length: [max: 100]
end
