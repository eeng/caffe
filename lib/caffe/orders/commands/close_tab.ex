defmodule Caffe.Orders.Commands.CloseTab do
  defstruct [:tab_id, :amount_paid]

  use Caffe.Command

  validates :tab_id, uuid: true
end
