defmodule CaffeWeb.Resolvers.Ordering do
  alias Caffe.Ordering
  alias Caffe.Ordering.Projections.Order
  alias Caffe.Repo
  alias Caffe.Authorization.Authorizer

  def place_order(_parent, params, %{context: context}) do
    with :ok <- Authorizer.authorize(:place_order, context[:current_user]) do
      Ordering.place_order(params, context[:current_user])
    end
  end

  def cancel_order(_parent, %{order_id: order_id} = params, %{context: context}) do
    with {:ok, order} <- Repo.fetch(Order, order_id),
         :ok <- Authorizer.authorize(:cancel_order, context[:current_user], order),
         :ok <- Ordering.cancel_order(params, context[:current_user]) do
      {:ok, "ok"}
    end
  end
end
