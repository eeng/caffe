defmodule Caffe.Menu do
  @moduledoc """
  The Menu bounded context boundary.
  """

  alias Caffe.Repo
  alias Caffe.Menu.{Item, Category}

  @doc """
  Creates or update the menu item
  """
  def save_item(attrs) do
    case (attrs[:id] && get_item(attrs[:id])) || {:ok, %Item{}} do
      {:ok, item} ->
        item
        |> Item.changeset(attrs)
        |> Repo.insert_or_update()

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
    case id && Repo.get(Item, id) do
      nil -> {:error, :not_found}
      item -> {:ok, item}
    end
  rescue
    Ecto.Query.CastError -> {:error, :not_found}
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
