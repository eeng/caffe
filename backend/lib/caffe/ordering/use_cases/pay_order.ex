defmodule Caffe.Ordering.UseCases.PayOrder do
  use Caffe.Mediator.UseCase
  alias Caffe.Ordering.Commands
  alias Caffe.Accounts.User

  defstruct [:user, :params]

  @impl true
  def execute(%PayOrder{user: user, params: params}) do
    params
    |> Map.put(:user_id, user.id)
    |> Commands.PayOrder.new()
    |> Router.dispatch(consistency: :strong)
    |> wrap_ok_result
  end

  @impl true
  def authorize(%PayOrder{user: %User{}}), do: true
end
