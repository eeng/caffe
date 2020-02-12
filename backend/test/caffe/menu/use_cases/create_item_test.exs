defmodule Caffe.Menu.UseCases.CreateItemTest do
  use Caffe.UseCaseCase, async: true
  alias Caffe.Menu
  alias Caffe.Menu.UseCases.CreateItem
  alias Caffe.Accounts.User

  describe "execute" do
    test "should insert and return the item" do
      dishes = insert!(:category)

      {:ok, item} =
        Menu.create_item(%{name: "Salmon", category: dishes, price: 10}, build(:admin))

      assert item.id
      assert item.price == Decimal.new(10)
    end

    test "should validate the attributes" do
      {:error, changeset} = Menu.create_item(%{}, build(:admin))
      refute changeset.valid?
    end

    test "should authorize the command" do
      {:error, :unauthorized} = Menu.create_item(%{}, nil)
    end
  end

  describe "authorize" do
    test "only admins can create menu items" do
      assert Authorizer.authorize?(%CreateItem{user: %User{role: "admin"}})
      refute Authorizer.authorize?(%CreateItem{user: %User{role: "customer"}})
      refute Authorizer.authorize?(%CreateItem{user: %User{role: "waitstaff"}})
      refute Authorizer.authorize?(%CreateItem{user: nil})
    end
  end
end
