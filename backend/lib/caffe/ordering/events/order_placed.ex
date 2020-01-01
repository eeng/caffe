defmodule Caffe.Ordering.Events.OrderPlaced do
  use Caffe.Constructor

  @derive Jason.Encoder
  defstruct [:order_id, :user_id, :customer_id, :customer_name, :items, :notes, :order_amount]
end
