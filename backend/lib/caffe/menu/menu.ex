defmodule Caffe.Menu do
  import Ecto.Query

  alias Caffe.Repo
  alias Caffe.Menu.{Item, Category}
  alias Caffe.Authorization.Authorizer

  def create_item(attrs, user) do
    with :ok <- Authorizer.authorize(:create_menu_item, user) do
      %Item{}
      |> Item.changeset(attrs)
      |> Repo.insert()
    end
  end

  def update_item(attrs, user) do
    with :ok <- Authorizer.authorize(:update_menu_item, user),
         {:ok, item} <- get_item(attrs[:id]) do
      item
      |> Item.changeset(attrs)
      |> Repo.update()
    else
      error -> error
    end
  end

  def delete_item(id, user) do
    with :ok <- Authorizer.authorize(:delete_menu_item, user),
         {:ok, item} <- get_item(id) do
      Repo.delete(item)
    else
      error -> error
    end
  end

  def list_items do
    Item |> order_by(asc: :name) |> Repo.all()
  end

  def get_item(id) do
    Repo.fetch(Item, id)
  end

  def list_categories do
    Repo.all(Category)
  end

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end
end
