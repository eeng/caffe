defmodule Caffe.Menu.UseCases.UpdateItemTest do
  use Caffe.UseCaseCase, async: true
  alias Caffe.Menu
  alias Caffe.Menu.UseCases.UpdateItem
  alias Caffe.Accounts.User

  describe "execute" do
    test "with id should update the item" do
      original = insert!(:menu_item, name: "Salmo")
      {:ok, updated} = Menu.update_item(%{id: original.id, name: "Salmon"}, build(:admin))
      assert original.id == updated.id
      assert "Salmon" == updated.name
    end

    test "with non-existent id" do
      assert {:error, :not_found} =
               params_for(:menu_item, id: -1) |> Menu.update_item(build(:admin))
    end
  end

  describe "authorize" do
    test "only admins can update menu items" do
      assert Authorizer.authorize?(%UpdateItem{user: %User{role: "admin"}})
      refute Authorizer.authorize?(%UpdateItem{user: %User{role: "customer"}})
      refute Authorizer.authorize?(%UpdateItem{user: %User{role: "waitstaff"}})
    end
  end
end
