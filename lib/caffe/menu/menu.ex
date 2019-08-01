defmodule Caffe.Menu do
  @moduledoc """
  The Menu bounded context boundary.
  """

  alias Caffe.Repo
  alias Caffe.Menu.Item

  def create_item(attrs) do
    %Item{id: UUID.uuid4()}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  def list_items do
    Repo.all(Item)
  end

  def get_item(id) do
    Repo.get(Item, id)
  end
end
