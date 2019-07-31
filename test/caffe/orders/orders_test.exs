defmodule Caffe.OrdersTest do
  use Caffe.EventStoreCase

  alias Caffe.Orders

  test "open tab" do
    {:ok, tab} = Orders.open_tab(%{table_number: 3})
    assert tab
  end
end
