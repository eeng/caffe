defmodule CaffeWeb.Schema.Context do
  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, data} <- CaffeWeb.Support.Authentication.verify(token),
         {:ok, user} <- get_user(data) do
      %{current_user: user}
    else
      _ -> %{current_user: nil}
    end
  end

  defp get_user(%{user_id: id}) do
    Caffe.Accounts.get_user(id)
  end
end
