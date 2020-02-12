defmodule Caffe.Menu.UseCases.GetItem do
  use Caffe.Mediator.UseCase
  alias Caffe.Menu.Item

  defstruct [:id]

  @impl true
  def authorize(%GetItem{}), do: true

  @impl true
  def execute(%GetItem{id: id}) do
    Repo.fetch(Item, id)
  end
end
