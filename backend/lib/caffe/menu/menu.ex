defmodule Caffe.Menu do
  alias Caffe.Repo
  alias Caffe.Mediator

  alias Caffe.Menu.UseCases.{
    CreateItem,
    UpdateItem,
    DeleteItem,
    ListItems,
    GetItem,
    ListCategories
  }

  def create_item(params, user) do
    %CreateItem{user: user, params: params} |> Mediator.dispatch()
  end

  def update_item(params, user) do
    %UpdateItem{user: user, params: params} |> Mediator.dispatch()
  end

  def delete_item(id, user) do
    %DeleteItem{user: user, id: id} |> Mediator.dispatch()
  end

  def list_items do
    %ListItems{} |> Mediator.dispatch()
  end

  def get_item(id) do
    %GetItem{id: id} |> Mediator.dispatch()
  end

  def list_categories do
    %ListCategories{} |> Mediator.dispatch()
  end

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end
end
