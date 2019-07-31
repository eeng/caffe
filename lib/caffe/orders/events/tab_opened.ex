defmodule Caffe.Orders.Events.TabOpened do
  @derive Jason.Encoder
  @enforce_keys [:tab_id, :table_number]
  defstruct [:tab_id, :table_number]
end
