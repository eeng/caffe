defmodule CaffeWeb.Resolvers.Menu do
  alias Caffe.Menu

  def list_items(_parent, _args, _resolution) do
    {:ok, Menu.list_items()}
  end

  def list_categories(_parent, _args, _resolution) do
    {:ok, Menu.list_categories()}
  end

  def create_item(_parent, params, _resolution) do
    Menu.create_item(params)
  end

  def update_item(_parent, params, _resolution) do
    Menu.update_item(params)
  end

  def delete_item(_parent, %{id: id}, _resolution) do
    Menu.delete_item(id)
  end
end
