defmodule Caffe.Orders.Commands.OpenTabTest do
  use Caffe.DataCase, async: true

  alias Caffe.Orders.Commands.OpenTab

  describe "validations" do
    test "table_number is required" do
      assert %{table_number: ["can't be blank"]} = errors_on(OpenTab, %{})
      assert %{table_number: ["is invalid"]} = errors_on(OpenTab, %{table_number: "asdf"})
      refute :table_number in error_fields_on(OpenTab, %{table_number: 1})
    end

    test "can't open a tab for a table number that already has another one opened" do
      error = ["table already has an open tab"]

      tab = insert!(:tab, table_number: 5, status: "opened")

      assert %{table_number: ^error} = errors_on(OpenTab, %{table_number: 5})

      tab |> change(%{status: "closed"}) |> Repo.update!()
      refute :table_number in error_fields_on(OpenTab, %{table_number: 5})

      insert!(:tab, table_number: 5, status: "opened")
      assert %{table_number: ^error} = errors_on(OpenTab, %{table_number: 5})
    end
  end
end
