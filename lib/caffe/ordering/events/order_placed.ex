defmodule Caffe.Ordering.Events.OrderPlaced do
  @derive Jason.Encoder
  defstruct [:order_id, :user_id, :customer_id, :customer_name, :items]
end
