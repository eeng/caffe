defmodule Caffe.MenusTest do
  use Caffe.DataCase

  alias Caffe.Menus
  alias Caffe.Menus.MenuItem

  describe "menu items service" do
    test "create_menu_item should insert and return the item" do
      {:ok, menu_item} = Menus.create_menu_item(%{name: "Salmon", category: "Dishes", price: 10})
      assert %MenuItem{name: "Salmon", price: 10} = menu_item
    end

    test "create_menu_item should validate the attributes" do
      {:error, changeset} = Menus.create_menu_item(%{})
      refute changeset.valid?
    end

    test "update_menu_item should save and return the updated item" do
      menu_item = insert!(:menu_item)
      {:ok, menu_item} = Menus.update_menu_item(menu_item, %{price: 99, is_drink: true})
      assert menu_item.price == 99
      assert menu_item.is_drink
    end

    test "list_menu_items should return all menu items" do
      menu_item = insert!(:menu_item)
      assert Menus.list_menu_items() == [menu_item]
    end
  end
end
