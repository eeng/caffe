defmodule Caffe.Menu do
  @moduledoc """
  The Menu bounded context boundary. Implemented with a CRUD approach.
  """

  alias Caffe.Repo
  alias Caffe.Menu.{Item, Category}

  def create_item(attrs) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  def update_item(attrs) do
    case get_item(attrs[:id]) do
      {:ok, item} ->
        item
        |> Item.changeset(attrs)
        |> Repo.update()

      error ->
        error
    end
  end

  def delete_item(id) do
    case get_item(id) do
      {:ok, item} -> Repo.delete(item)
      error -> error
    end
  end

  def list_items do
    Repo.all(Item)
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
