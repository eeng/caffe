defmodule Caffe.Ordering.Events.ItemsServed do
  @derive Jason.Encoder
  defstruct [:order_id, :user_id, :item_ids]
end
