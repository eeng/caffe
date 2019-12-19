defmodule CaffeWeb.Resolvers.Accounts do
  def login(_parent, %{email: email, password: password}, _resolution) do
    case Caffe.Accounts.authenticate(email, password) do
      {:ok, user} ->
        token = CaffeWeb.Support.Authentication.sign(%{user_id: user.id})
        {:ok, %{token: token, user: user}}

      error ->
        error
    end
  end
end
