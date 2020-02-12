defmodule Caffe.Ordering.UseCases.ServeItem do
  use Caffe.Mediator.UseCase

  defstruct [:order]

  @impl true
  def authorize(%ServeItem{order: %{is_drink: true, state: "pending"}}), do: true
  def authorize(%ServeItem{order: %{is_drink: false, state: "prepared"}}), do: true

  @impl true
  def execute(_) do
    {:error, :only_used_for_authorization}
  end
end
