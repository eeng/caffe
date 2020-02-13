defmodule Caffe.Ordering.UseCases.CancelOrder do
  use Caffe.Mediator.UseCase, skip_authorization: true

  alias Caffe.Ordering.Commands
  alias Caffe.Ordering.Projections.Order
  alias Caffe.Accounts.User
  alias Caffe.Authorization.Authorizer

  # The resource will be the order fetched from DB for authorization
  defstruct [:user, :id, :resource]

  @impl true
  def execute(%CancelOrder{id: id, user: user} = use_case) do
    with {:ok, order} <- Repo.fetch(Order, id),
         :ok <- Authorizer.authorize(%{use_case | resource: order}) do
      Commands.CancelOrder.new(order_id: id, user_id: user.id)
      |> Router.dispatch(consistency: :strong)
      |> wrap_ok_result
    end
  end

  @impl true
  def authorize(%CancelOrder{
        user: %User{role: "customer", id: user_id},
        resource: %Order{} = order
      }) do
    %{customer_id: cust_id, state: state} = order
    cust_id == user_id && state == "pending"
  end

  def authorize(%CancelOrder{user: %User{}, resource: %Order{state: state}}),
    do: state == "pending"
end
