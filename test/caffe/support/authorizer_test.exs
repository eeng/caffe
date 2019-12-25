defmodule Caffe.Support.AuthorizerTest do
  use ExUnit.Case, async: true

  alias Caffe.Support.Authorizer
  alias __MODULE__.FakeAuthPolicy

  test "authorize? returns a boolean" do
    assert Authorizer.authorize?(FakeAuthPolicy, :launch_missiles, %{role: "president"})
    refute Authorizer.authorize?(FakeAuthPolicy, :launch_missiles, %{role: "vp"})
  end

  test "authorize returns :ok or :error tuple" do
    assert :ok = Authorizer.authorize(FakeAuthPolicy, :launch_missiles, %{role: "president"})

    assert {:error, :unauthorized} =
             Authorizer.authorize(FakeAuthPolicy, :launch_missiles, %{role: "vp"})
  end

  defmodule FakeAuthPolicy do
    @behaviour Authorizer.Policy

    def authorize(:launch_missiles, %{role: "president"}, _), do: true
    def authorize(_, _, _), do: false
  end
end
