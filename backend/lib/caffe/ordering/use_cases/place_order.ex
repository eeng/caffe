defmodule Caffe.Ordering.UseCases.PlaceOrder do
  use Caffe.Mediator.UseCase
  alias Caffe.Ordering.Commands
  alias Caffe.Ordering.Projections.Order
  alias Caffe.Accounts.User
  alias Caffe.Menu

  defstruct [:user, :params]

  @impl true
  def authorize(%PlaceOrder{user: %User{}}), do: true

  @impl true
  def execute(%PlaceOrder{user: user, params: params}) do
    id = UUID.uuid4()

    command =
      params
      |> Map.merge(%{order_id: id, user_id: user.id})
      |> update_in([:items, Access.all()], &fetch_item_details/1)
      |> assign_customer_id(user)
      |> Commands.PlaceOrder.new()

    case Router.dispatch(command, consistency: :strong) do
      :ok -> {:ok, get_order(id)}
      reply -> reply
    end
  end

  defp get_order(id) do
    Repo.get(Order, id) |> Repo.preload(:items)
  end

  defp fetch_item_details(%{menu_item_id: id} = item) do
    {:ok, menu_item} = Menu.get_item(id)

    Map.merge(item, %{
      menu_item_name: menu_item.name,
      price: menu_item.price,
      is_drink: menu_item.is_drink
    })
  end

  defp assign_customer_id(command, %User{id: user_id, role: "customer"}) do
    command |> Map.put(:customer_id, user_id)
  end

  defp assign_customer_id(command, _), do: command
end
