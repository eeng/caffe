defmodule Caffe.Accounts.UseCases.CreateUserTest do
  use Caffe.UseCaseCase, async: true
  alias Caffe.Accounts.UseCases.CreateUser

  describe "execute" do
    test "should store the password encrypted" do
      {:ok, user} = params_for(:user, password: "secret") |> create_user()
      assert user.password != "secret"
    end

    test "should authorize the command" do
      {:error, :unauthorized} = create_user(%{}, build(:customer))
      {:error, :unauthorized} = create_user(%{}, nil)
    end

    def create_user(params, user \\ build(:admin)) do
      %CreateUser{params: params, user: user} |> Mediator.dispatch()
    end
  end
end
