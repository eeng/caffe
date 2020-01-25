defmodule Caffe.AccountsTest do
  use Caffe.DataCase, async: true

  alias Caffe.Accounts
  alias Caffe.Accounts.User

  describe "autheticate" do
    setup do
      [user: insert!(:user, email: "alice@acme.com", password: "secret123")]
    end

    test "valid credentials" do
      assert {:ok, %User{email: "alice@acme.com"}} =
               Accounts.authenticate("alice@acme.com", "secret123")
    end

    test "invalid credentials" do
      assert {:error, :invalid_credentials} = Accounts.authenticate("alice@acme.com", "Secret123")
      assert {:error, :invalid_credentials} = Accounts.authenticate("bob@acme.com", "secret123")
      assert {:error, :invalid_credentials} = Accounts.authenticate("alice@acme.com", "")
    end
  end

  describe "create_user" do
    test "should store the password encrypted" do
      {:ok, user} =
        params_for(:user) |> Map.put(:password, "secret") |> Accounts.create_user(build(:admin))

      assert user.password != "secret"
    end

    test "should authorize the command" do
      {:error, :unauthorized} = Accounts.create_user(%{}, build(:customer))
      {:error, :unauthorized} = Accounts.create_user(%{}, nil)
    end
  end

  describe "list_users" do
    test "returns all users" do
      insert!(:user, name: "Alice")
      insert!(:user, name: "Bob")

      assert {:ok, [%User{name: "Alice"}, %User{name: "Bob"}]} =
               Accounts.list_users(build(:admin))
    end

    test "only admins can do it" do
      {:error, :unauthorized} = Accounts.list_users(build(:customer))
      {:error, :unauthorized} = Accounts.list_users(nil)
    end
  end
end
