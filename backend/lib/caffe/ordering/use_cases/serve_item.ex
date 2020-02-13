defmodule Caffe.Ordering.UseCases.ServeItem do
  use Caffe.Mediator.UseCase

  defstruct [:resource]

  @impl true
  def execute(_) do
    {:error, :only_used_for_authorization}
  end

  @impl true
  def authorize(%ServeItem{resource: %{is_drink: true, state: "pending"}}), do: true
  def authorize(%ServeItem{resource: %{is_drink: false, state: "prepared"}}), do: true
end
