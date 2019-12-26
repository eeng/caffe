defmodule CaffeWeb.Resolvers.Accounts do
  alias CaffeWeb.Support.Authentication
  alias Caffe.Accounts
  alias Caffe.Authorization.Authorizer

  def login(_parent, %{email: email, password: password}, _resolution) do
    case Accounts.authenticate(email, password) do
      {:ok, user} ->
        token = Authentication.sign(%{user_id: user.id})
        {:ok, %{token: token, user: user}}

      error ->
        error
    end
  end

  def list_users(_parent, _params, %{context: context}) do
    with :ok <- Authorizer.authorize(:list_users, context[:current_user]) do
      {:ok, Accounts.list_users()}
    end
  end
end
