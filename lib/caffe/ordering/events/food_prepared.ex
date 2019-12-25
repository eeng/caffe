defmodule Caffe.Ordering.Events.FoodPrepared do
  @derive Jason.Encoder
  defstruct [:order_id, :user_id, :item_ids]
end
