defmodule Caffe.Menu.UseCases.DeleteItem do
  use Caffe.Mediator.UseCase
  alias Caffe.Menu.Item

  defstruct [:user, :id]

  @impl true
  def authorize(%DeleteItem{user: %{role: "admin"}}), do: true

  @impl true
  def execute(%DeleteItem{id: id}) do
    case Repo.fetch(Item, id) do
      {:ok, item} -> Repo.delete(item)
      error -> error
    end
  end
end
