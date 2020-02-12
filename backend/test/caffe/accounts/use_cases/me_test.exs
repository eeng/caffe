defmodule Caffe.Accounts.UseCases.MeTest do
  use Caffe.UseCaseCase, async: true
  alias Caffe.Accounts.UseCases.Me
  alias Caffe.Accounts.User

  describe "authorize" do
    test "logged in users can see their profiles" do
      assert Authorizer.authorize?(%Me{user: %User{role: "customer"}})
      refute Authorizer.authorize?(%Me{user: nil})
    end
  end
end
