defmodule Caffe.AccountsTest do
  use Caffe.DataCase, async: true

  alias Caffe.Accounts
  alias Caffe.Accounts.User

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
