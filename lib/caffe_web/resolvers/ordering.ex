defmodule CaffeWeb.Resolvers.Ordering do
  alias Caffe.Ordering

  def place_order(_parent, params, %{context: %{current_user: user}}) do
    Ordering.place_order(params, user)
  end

  def cancel_order(_parent, params, %{context: %{current_user: user}}) do
    with :ok <- Ordering.cancel_order(params, user) do
      {:ok, "ok"}
    end
  end
end
