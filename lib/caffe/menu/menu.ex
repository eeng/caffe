defmodule Caffe.Menu do
  @moduledoc """
  The Menu bounded context boundary.
  """

  alias Caffe.Repo
  alias Caffe.Menu.{Item, Category}

  def create_item(attrs) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  def delete_item(id) do
    case Repo.get(Item, id) do
      nil -> {:error, "not found"}
      item -> Repo.delete(item)
    end
  end

  def list_items do
    Repo.all(Item)
  end

  def get_item(id) do
    Repo.get(Item, id)
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
