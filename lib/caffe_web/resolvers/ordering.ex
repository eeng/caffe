defmodule CaffeWeb.Resolvers.Ordering do
  alias Caffe.Ordering

  def place_order(_parent, params, %{context: %{current_user: user}}) do
    with {:ok, order} <- Ordering.place_order(params, user) do
      Absinthe.Subscription.publish(CaffeWeb.Endpoint, order, new_order: [order.customer_id, "*"])
      {:ok, order}
    end
  end
end
