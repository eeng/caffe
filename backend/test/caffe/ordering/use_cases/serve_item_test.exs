defmodule Caffe.Ordering.UseCases.ServeItemTest do
  use Caffe.UseCaseCase
  alias Caffe.Ordering.UseCases.ServeItem
  import Caffe.Authorization.Authorizer, only: [authorize?: 1]

  describe "authorize" do
    test "a drink can be served on pending state" do
      assert authorize?(%ServeItem{order: %{is_drink: true, state: "pending"}})
      refute authorize?(%ServeItem{order: %{is_drink: true, state: "served"}})
    end

    test "a food can be served on prepared state" do
      assert authorize?(%ServeItem{order: %{is_drink: false, state: "prepared"}})
      refute authorize?(%ServeItem{order: %{is_drink: false, state: "preparing"}})
      refute authorize?(%ServeItem{order: %{is_drink: false, state: "pending"}})
      refute authorize?(%ServeItem{order: %{is_drink: false, state: "served"}})
    end
  end
end
