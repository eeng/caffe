defmodule CaffeWeb.Resolvers.Ordering do
  alias Caffe.Ordering

  def place_order(_parent, params, %{context: %{current_user: user}}) do
    params |> Map.put(:user_id, user.id) |> Ordering.place_order()
  end
end
