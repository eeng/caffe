defmodule Caffe.Orders.Commands.OpenTab do
  defstruct [:tab_id, :table_number]
  # TODO waiter?

  use Vex.Struct

  validates :tab_id, uuid: true
  validates :table_number, number: true
end
