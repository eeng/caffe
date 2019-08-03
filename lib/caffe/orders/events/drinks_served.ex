defmodule Caffe.Orders.Events.DrinksServed do
  @derive Jason.Encoder
  defstruct [:tab_id, :item_ids]
end
