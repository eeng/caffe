defmodule Caffe.Menu.UseCases.ListItems do
  use Caffe.Mediator.UseCase
  alias Caffe.Menu.Item

  defstruct []

  @impl true
  def authorize(%ListItems{}), do: true

  @impl true
  def execute(%ListItems{}) do
    {:ok, Item |> order_by(asc: :name) |> Repo.all()}
  end
end
