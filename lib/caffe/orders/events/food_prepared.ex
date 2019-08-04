defmodule Caffe.Orders.Events.FoodPrepared do
  @derive Jason.Encoder
  defstruct [:tab_id, :item_ids]
end
