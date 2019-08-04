defmodule Caffe.Orders.Events.ItemsServed do
  @derive Jason.Encoder
  defstruct [:tab_id, :item_ids]
end
