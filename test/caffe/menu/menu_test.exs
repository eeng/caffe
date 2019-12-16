defmodule Caffe.MenuTest do
  use Caffe.DataCase, async: true

  alias Caffe.Menu

  describe "menu items service" do
    test "create_item should insert and return the item" do
      dishes = insert!(:category)
      {:ok, item} = Menu.create_item(%{name: "Salmon", category: dishes, price: 10})
      assert item.id
      assert item.price == Decimal.new(10)
    end

    test "create_item should validate the attributes" do
      {:error, changeset} = Menu.create_item(%{})
      refute changeset.valid?
    end

    test "update_item should save and return the updated item" do
      item = insert!(:menu_item)
      {:ok, item} = Menu.update_item(item, %{price: 99, is_drink: true})
      assert item.price == Decimal.new(99)
      assert item.is_drink
    end

    test "list_items should return all menu items" do
      insert!(:menu_item)
      assert [%Menu.Item{}] = Menu.list_items()
    end
  end
end
