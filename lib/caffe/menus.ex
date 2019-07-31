defmodule Caffe.Menus do
  @moduledoc """
  The Menus bounded context boundary.
  """

  alias Caffe.Repo
  alias Caffe.Menus.{Menu, MenuItem}

  def create_menu_item(attrs) do
    %MenuItem{id: UUID.uuid4()}
    |> MenuItem.changeset(attrs)
    |> Repo.insert()
  end

  def update_menu_item(%MenuItem{} = menu_item, attrs) do
    menu_item
    |> MenuItem.changeset(attrs)
    |> Repo.update()
  end

  def delete_menu_item(%MenuItem{} = menu_item) do
    Repo.delete(menu_item)
  end

  def list_menu_items do
    Repo.all(MenuItem)
  end

  def get_current_menu do
    %Menu{items: list_menu_items()}
  end

  def get_menu_item(id) do
    Repo.get(MenuItem, id)
  end
end
