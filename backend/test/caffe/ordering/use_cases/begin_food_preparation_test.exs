defmodule Caffe.Ordering.UseCases.BeginFoodPreparationTest do
  use Caffe.UseCaseCase
  use Caffe.EventStoreCase

  alias Caffe.Ordering.UseCases.BeginFoodPreparation
  alias Caffe.Accounts.User

  describe "authorization" do
    test "only the chef and admin can do it" do
      assert Authorizer.authorize?(%BeginFoodPreparation{user: %User{role: "chef"}})
      assert Authorizer.authorize?(%BeginFoodPreparation{user: %User{role: "admin"}})
      refute Authorizer.authorize?(%BeginFoodPreparation{user: %User{role: "customer"}})
    end
  end
end
