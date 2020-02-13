defmodule Caffe.Ordering.UseCases.MarkItemsServed do
  use Caffe.Mediator.UseCase
  alias Caffe.Ordering.Commands

  defstruct [:user, :params]

  @impl true
  def execute(%MarkItemsServed{user: user, params: params}) do
    params
    |> Map.put(:user_id, user.id)
    |> Commands.MarkItemsServed.new()
    |> Router.dispatch(consistency: :strong)
    |> wrap_ok_result
  end

  @impl true
  def authorize(%MarkItemsServed{user: %{role: role}}), do: role in ~w[waitstaff admin]
end
