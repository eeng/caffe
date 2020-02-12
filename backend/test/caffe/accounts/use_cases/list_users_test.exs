defmodule Caffe.Accounts.UseCases.ListUsersTest do
  use Caffe.UseCaseCase, async: true
  alias Caffe.Accounts.UseCases.ListUsers
  alias Caffe.Accounts.User

  describe "execute" do
    test "returns all users" do
      insert!(:user, name: "Alice")
      insert!(:user, name: "Bob")

      assert {:ok, [%User{name: "Alice"}, %User{name: "Bob"}]} = list_users(build(:admin))
    end

    test "only admins can do it" do
      {:error, :unauthorized} = list_users(build(:customer))
      {:error, :unauthorized} = list_users(nil)
    end

    def list_users(user) do
      %ListUsers{user: user} |> Mediator.dispatch()
    end
  end

  describe "authorize" do
    test "only admins can list users" do
      assert Authorizer.authorize?(%ListUsers{user: %User{role: "admin"}})
      refute Authorizer.authorize?(%ListUsers{user: %User{role: "customer"}})
      refute Authorizer.authorize?(%ListUsers{user: %User{role: "waitstaff"}})
    end
  end
end
