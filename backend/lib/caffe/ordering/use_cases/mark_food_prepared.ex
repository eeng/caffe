defmodule Caffe.Ordering.UseCases.MarkFoodPrepared do
  use Caffe.Mediator.UseCase
  alias Caffe.Ordering.Commands

  defstruct [:user, :params]

  @impl true
  def authorize(%MarkFoodPrepared{user: %{role: role}}), do: role in ~w[chef admin]

  @impl true
  def execute(%MarkFoodPrepared{user: user, params: params}) do
    params
    |> Map.put(:user_id, user.id)
    |> Commands.MarkFoodPrepared.new()
    |> Router.dispatch(consistency: :strong)
    |> wrap_ok_result
  end
end
