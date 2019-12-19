defmodule Caffe.Menu.ItemTest do
  use Caffe.DataCase, async: true

  alias Caffe.Menu.Item
  alias Caffe.Repo

  describe "validations" do
    test "name is required" do
      assert %{name: ["can't be blank"]} = errors_on(Item, %{})
    end

    test "name is unique" do
      insert!(:menu_item, name: "Chips")
      {:error, changeset} = build(:menu_item) |> Item.changeset(%{name: "Chips"}) |> Repo.insert()
      assert %{name: ["has already been taken"]} = errors_on(changeset)
    end

    test "price must be positive" do
      assert %{price: ["can't be blank"]} = errors_on(Item, %{})
      assert %{price: ["must be greater than or equal to 0"]} = errors_on(Item, %{price: -1})
    end
  end
end
