defmodule Caffe.Orders.Events.FoodOrdered do
  @derive Jason.Encoder
  defstruct [:tab_id, :items]
end
