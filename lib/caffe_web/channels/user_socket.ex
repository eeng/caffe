defmodule CaffeWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: CaffeWeb.Schema

  def connect(params, socket, _connect_info) do
    context = build_context(params)
    socket = Absinthe.Phoenix.Socket.put_options(socket, context: context)
    {:ok, socket}
  end

  defp build_context(params) do
    with %{"token" => token} <- params,
         {:ok, %{user_id: id}} <- CaffeWeb.Support.Authentication.verify(token),
         {:ok, user} <- Caffe.Accounts.get_user(id) do
      %{current_user: user}
    else
      _ -> %{}
    end
  end

  def id(_socket), do: nil
end
