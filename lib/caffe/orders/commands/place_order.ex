defmodule Caffe.Orders.Commands.PlaceOrder do
  defstruct [:tab_id, :items]

  use Vex.Struct

  validates :tab_id, uuid: true
  validates :items, by: &is_list/1
end
