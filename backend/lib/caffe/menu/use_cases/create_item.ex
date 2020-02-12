defmodule Caffe.Menu.UseCases.CreateItem do
  use Caffe.Mediator.UseCase
  alias Caffe.Menu.Item

  defstruct [:user, :params]

  @impl true
  def authorize(%CreateItem{user: %{role: "admin"}}), do: true

  @impl true
  def execute(%CreateItem{params: params}) do
    %Item{}
    |> Item.changeset(params)
    |> Repo.insert()
  end
end
