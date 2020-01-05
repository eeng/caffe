defmodule CaffeWeb.Resolvers.Accounts do
  alias CaffeWeb.Support.Authentication
  alias Caffe.Accounts

  def login(_parent, %{email: email, password: password}, _resolution) do
    case Accounts.authenticate(email, password) do
      {:ok, user} ->
        token = Authentication.sign(%{user_id: user.id})
        {:ok, %{token: token, user: user}}

      error ->
        error
    end
  end

  def me(_parent, _params, %{context: %{current_user: user}}) do
    Accounts.get_user(user.id)
  end

  def list_users(_parent, _params, _resolution) do
    {:ok, Accounts.list_users()}
  end
end
