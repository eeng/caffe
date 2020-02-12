defmodule Caffe.Ordering.UseCases.MarkItemsServedTest do
  use Caffe.UseCaseCase
  use Caffe.EventStoreCase

  alias Caffe.Ordering.UseCases.MarkItemsServed
  alias Caffe.Accounts.User

  describe "authorization" do
    test "only the waitstaff and admin can do it" do
      assert Authorizer.authorize?(%MarkItemsServed{user: %User{role: "waitstaff"}})
      assert Authorizer.authorize?(%MarkItemsServed{user: %User{role: "admin"}})
      refute Authorizer.authorize?(%MarkItemsServed{user: %User{role: "customer"}})
    end
  end
end
