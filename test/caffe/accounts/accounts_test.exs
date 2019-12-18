defmodule Caffe.AccountsTest do
  use Caffe.DataCase, async: true

  alias Caffe.Accounts
  alias Caffe.Accounts.User

  describe "create_user" do
    test "should store the password encrypted" do
      {:ok, user} = params_for(:user) |> Map.put(:password, "secret") |> Accounts.create_user()
      assert user.password != "secret"
    end
  end

  describe "autheticate" do
    setup do
      [
        user:
          params_for(:user, username: "alice", password: "secret123")
          |> Accounts.create_user()
      ]
    end

    test "valid credentials" do
      assert {:ok, %User{username: "alice"}} = Accounts.authenticate("alice", "secret123")
    end

    test "invalid credentials" do
      assert {:error, :invalid_credentials} = Accounts.authenticate("alice", "Secret123")
      assert {:error, :invalid_credentials} = Accounts.authenticate("bob", "secret123")
      assert {:error, :invalid_credentials} = Accounts.authenticate("alice", "")
    end
  end
end
