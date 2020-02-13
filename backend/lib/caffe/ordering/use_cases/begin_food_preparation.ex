defmodule Caffe.Ordering.UseCases.BeginFoodPreparation do
  use Caffe.Mediator.UseCase
  alias Caffe.Ordering.Commands

  defstruct [:user, :params]

  @impl true
  def execute(%BeginFoodPreparation{user: user, params: params}) do
    params
    |> Map.put(:user_id, user.id)
    |> Commands.BeginFoodPreparation.new()
    |> Router.dispatch(consistency: :strong)
    |> wrap_ok_result
  end

  @impl true
  def authorize(%BeginFoodPreparation{user: %{role: role}}), do: role in ~w[chef admin]
end
