defmodule Caffe.Ordering.UseCases.GetActivityFeedTest do
  use Caffe.UseCaseCase

  alias Caffe.Ordering.UseCases.GetActivityFeed
  alias Caffe.Accounts.User

  describe "execute" do
    test "returns the activities sorted by published desc" do
      a3 = insert!(:activity, published: ~U[2016-05-24 13:26:08Z])
      a1 = insert!(:activity, published: ~U[2016-05-24 13:26:06Z])
      a2 = insert!(:activity, published: ~U[2016-05-24 13:26:07Z])

      assert_lists_equal [a3, a2, a1], activity_feed(), by: :published
    end

    def activity_feed do
      with {:ok, activities} <- Caffe.Ordering.get_activity_feed(build(:admin)) do
        activities
      end
    end
  end

  describe "authorize" do
    test "customers and guests can't view activities" do
      refute Authorizer.authorize?(%GetActivityFeed{user: %User{role: "customer"}})
      refute Authorizer.authorize?(%GetActivityFeed{user: nil})
    end

    test "employees can view them" do
      assert Authorizer.authorize?(%GetActivityFeed{user: %User{role: "cashier"}})
      assert Authorizer.authorize?(%GetActivityFeed{user: %User{role: "admin"}})
    end
  end
end
