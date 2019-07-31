defmodule Caffe.Orders.Events.DrinksOrdered do
  @derive Jason.Encoder
  defstruct [:tab_id, :items]
end
