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
end
