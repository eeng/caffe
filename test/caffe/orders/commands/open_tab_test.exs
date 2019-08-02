defmodule Caffe.Orders.Commands.OpenTabTest do
  use Caffe.CommandCase

  alias Caffe.Orders.Commands.OpenTab

  describe "validations" do
    test "table_number is required" do
      assert "must be a number" in errors_on(%OpenTab{}).table_number
    end

    test "can't open a tab for a table number that already has another one opened" do
      refute errors_on(%OpenTab{table_number: 5}) |> Map.has_key?(:table_number)
      tab = insert!(:tab, table_number: 5, status: "opened")
      assert "table already has an open tab" in errors_on(%OpenTab{table_number: 5}).table_number
      tab |> change(%{status: "closed"}) |> Repo.update!()
      refute errors_on(%OpenTab{table_number: 5}) |> Map.has_key?(:table_number)
    end
  end
end
