defmodule Caffe.Orders.Events.TabClosed do
  @derive Jason.Encoder
  defstruct [:tab_id, :order_amount, :amount_paid, :tip_amount]
end
