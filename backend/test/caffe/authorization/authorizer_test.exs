defmodule Caffe.Authorization.AuthorizerTest do
  use ExUnit.Case, async: true

  alias Caffe.Authorization.Authorizer
  alias Caffe.Accounts.User

  describe "authorized_actions" do
    test "returns an array of all permitted actions" do
      assert [:me, :place_order, :pay_order] ==
               Authorizer.authorized_actions(%User{role: "customer"})
    end
  end
end
