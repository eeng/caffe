defmodule Caffe.Menu.UseCases.DeleteItemTest do
  use Caffe.UseCaseCase, async: true
  alias Caffe.Menu.UseCases.DeleteItem
  alias Caffe.Accounts.User

  describe "authorize" do
    test "only admins can delete menu items" do
      assert Authorizer.authorize?(%DeleteItem{user: %User{role: "admin"}})
      refute Authorizer.authorize?(%DeleteItem{user: %User{role: "customer"}})
      refute Authorizer.authorize?(%DeleteItem{user: %User{role: "waitstaff"}})
    end
  end
end
