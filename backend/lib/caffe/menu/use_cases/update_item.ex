defmodule Caffe.Menu.UseCases.UpdateItem do
  use Caffe.Mediator.UseCase
  alias Caffe.Menu.Item

  defstruct [:user, :params]

  @impl true
  def authorize(%UpdateItem{user: %{role: "admin"}}), do: true

  @impl true
  def execute(%UpdateItem{params: params}) do
    case Repo.fetch(Item, params[:id]) do
      {:ok, item} ->
        item
        |> Item.changeset(params)
        |> Repo.update()

      error ->
        error
    end
  end
end
