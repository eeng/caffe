defmodule Caffe.Orders.Aggregates.TabTest do
  use Caffe.AggregateCase, aggregate: Caffe.Orders.Aggregates.Tab

  use Caffe.Orders.Aliases

  describe "open tab" do
    @tab_id UUID.uuid4()

    test "should succeed when valid" do
      assert_event(
        %OpenTab{tab_id: @tab_id, table_number: 3},
        %TabOpened{tab_id: @tab_id, table_number: 3}
      )
    end

    test "can't open already opened tabs" do
      assert_error(
        %TabOpened{tab_id: @tab_id, table_number: 3},
        %OpenTab{tab_id: @tab_id},
        {:error, :tab_already_opened}
      )
    end
  end
end
