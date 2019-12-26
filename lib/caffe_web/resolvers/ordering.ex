defmodule CaffeWeb.Resolvers.Ordering do
  alias Caffe.Ordering
  alias Caffe.Ordering.Projections.Order
  alias Caffe.Repo
  alias Caffe.Support.Authorizer
  alias Caffe.Ordering.AuthPolicy

  def place_order(_parent, params, %{context: context}) do
    with :ok <- Authorizer.authorize(AuthPolicy, :place_order, context[:current_user]) do
      Ordering.place_order(params, context[:current_user])
    end
  end

  def cancel_order(_parent, %{order_id: order_id} = params, %{context: %{current_user: user}}) do
    with {:ok, order} <- Repo.fetch(Order, order_id),
         :ok <- Authorizer.authorize(AuthPolicy, :cancel_order, user, order),
         :ok <- Ordering.cancel_order(params, user) do
      {:ok, "ok"}
    end
  end
end
