defmodule Caffe.Ordering.Events.OrderPaid do
  @derive Jason.Encoder
  defstruct [:order_id, :order_amount, :amount_paid, :tip_amount]
end
