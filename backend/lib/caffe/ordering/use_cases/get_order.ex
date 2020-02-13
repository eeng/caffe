defmodule Caffe.Ordering.UseCases.GetOrder do
  use Caffe.Mediator.UseCase, skip_authorization: true

  alias Caffe.Ordering.Projections.Order
  alias Caffe.Accounts.User
  alias Caffe.Authorization.Authorizer

  defstruct [:user, :id, :order]

  @impl true
  def execute(%GetOrder{id: id} = use_case) do
    with {:ok, order} <- Repo.fetch(Order, id),
         :ok <- Authorizer.authorize(%{use_case | order: order}) do
      {:ok, order |> Repo.preload(:items)}
    end
  end

  @impl true
  def authorize(%GetOrder{
        user: %User{role: "customer", id: user_id},
        order: %Order{customer_id: cust_id}
      }),
      do: user_id == cust_id

  def authorize(%GetOrder{user: %User{}}), do: true
end
