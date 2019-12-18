defmodule Caffe.MenuTest do
  use Caffe.DataCase, async: true

  alias Caffe.Menu

  describe "create_item" do
    test "should insert and return the item" do
      dishes = insert!(:category)
      {:ok, item} = Menu.create_item(%{name: "Salmon", category: dishes, price: 10})
      assert item.id
      assert item.price == Decimal.new(10)
    end

    test "should validate the attributes" do
      {:error, changeset} = Menu.create_item(%{})
      refute changeset.valid?
    end
  end

  describe "update_item" do
    test "with id should update the item" do
      original = insert!(:menu_item, name: "Salmo")
      {:ok, updated} = Menu.update_item(%{id: original.id, name: "Salmon"})
      assert original.id == updated.id
      assert "Salmon" == updated.name
    end

    test "with non-existent id" do
      assert {:error, :not_found} =
               params_for(:menu_item) |> Map.put(:id, -1) |> Menu.update_item()

      assert {:error, :not_found} =
               params_for(:menu_item) |> Map.put(:id, "asdf") |> Menu.update_item()
    end
  end

  describe "list_items" do
    test "should return all menu items" do
      insert!(:menu_item, name: "Chicken")
      insert!(:menu_item, name: "Beef")

      assert ["Beef", "Chicken"] == Menu.list_items() |> Enum.map(& &1.name) |> Enum.sort()
    end
  end

  describe "get_item" do
    test "with existent id" do
      item = insert!(:menu_item)
      {:ok, persisted} = Menu.get_item(item.id)
      assert item.id == persisted.id
    end

    test "with non-existent id" do
      {:error, :not_found} = Menu.get_item(0)
      {:error, :not_found} = Menu.get_item("asdf")
      {:error, :not_found} = Menu.get_item(nil)
    end
  end
end
