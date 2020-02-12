defmodule Caffe.Accounts.UseCases.AuthenticateTest do
  use Caffe.UseCaseCase, async: true
  alias Caffe.Accounts.UseCases.Authenticate
  alias Caffe.Accounts.User

  describe "execute" do
    setup do
      [user: insert!(:user, email: "alice@acme.com", password: "secret123")]
    end

    test "valid credentials" do
      assert {:ok, %User{email: "alice@acme.com"}} = authenticate("alice@acme.com", "secret123")
    end

    test "invalid credentials" do
      assert {:error, :invalid_credentials} = authenticate("alice@acme.com", "Secret123")
      assert {:error, :invalid_credentials} = authenticate("bob@acme.com", "secret123")
      assert {:error, :invalid_credentials} = authenticate("alice@acme.com", "")
    end

    def authenticate(email, password) do
      %Authenticate{email: email, password: password} |> Mediator.dispatch()
    end
  end
end
