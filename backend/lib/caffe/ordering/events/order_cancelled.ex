defmodule Caffe.Ordering.Events.OrderCancelled do
  @derive Jason.Encoder
  defstruct [:order_id, :user_id, :order_amount, :amount_paid, :tip_amount]
end
