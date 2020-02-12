defmodule Caffe.Authorization.AuthorizerTest do
  use ExUnit.Case, async: true
  import Caffe.Support.CustomAssertions
  alias Caffe.Authorization.Authorizer
  alias Caffe.Accounts.User

  describe "authorized_use_cases" do
    test "returns an array of strings representing the authorized use cases" do
      assert_contain_exactly(
        ~w[place_order pay_order get_order list_orders],
        Authorizer.authorized_use_cases(%User{role: "customer"})
      )
    end
  end
end
