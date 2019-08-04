defmodule Caffe.Orders.Events.FoodBeingPrepared do
  @derive Jason.Encoder
  defstruct [:tab_id, :item_ids]
end
