defmodule Caffe.Ordering.UseCases.GetWaitstaffOrders do
  use Caffe.Mediator.UseCase

  alias Caffe.Ordering.Projections.Order
  alias Caffe.Accounts.User

  defstruct [:user]

  @impl true
  def execute(%GetWaitstaffOrders{}) do
    {:ok, query() |> Repo.all()}
  end

  def query do
    from o in Order,
      where: o.state in ~w[pending served],
      join: i in assoc(o, :items),
      order_by: [o.order_date, not i.is_drink, i.menu_item_name],
      preload: [items: i]
  end

  @impl true
  def authorize(%GetWaitstaffOrders{user: %User{role: role}}),
    do: role in ~w[waitstaff cashier admin]
end
