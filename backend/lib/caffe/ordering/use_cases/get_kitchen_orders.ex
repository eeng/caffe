defmodule Caffe.Ordering.UseCases.GetKitchenOrders do
  use Caffe.Mediator.UseCase

  alias Caffe.Ordering.Projections.Order
  alias Caffe.Accounts.User

  defstruct [:user]

  @impl true
  def authorize(%GetKitchenOrders{user: %User{role: role}}), do: role in ~w[chef cashier admin]

  @impl true
  def execute(%GetKitchenOrders{}) do
    {:ok, query() |> Repo.all()}
  end

  def query do
    from o in Order,
      where: o.state in ~w[pending],
      join: i in assoc(o, :items),
      where: i.state in ~w[pending preparing] and i.is_drink == false,
      order_by: [o.order_date, i.menu_item_name],
      preload: [items: i]
  end
end
