defmodule Caffe.Orders.Events.TabOpened do
  @derive Jason.Encoder
  defstruct [:tab_id, :table_number]
end
