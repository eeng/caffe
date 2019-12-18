defmodule CaffeWeb.Resolvers.Menu do
  def list_items(_parent, _args, _resolution) do
    {:ok, Caffe.Menu.list_items()}
  end

  def list_categories(_parent, _args, _resolution) do
    {:ok, Caffe.Menu.list_categories()}
  end

  def create_item(_parent, params, _resolution) do
    Caffe.Menu.create_item(params)
  end

  def update_item(_parent, params, _resolution) do
    Caffe.Menu.update_item(params)
  end

  def delete_item(_parent, %{id: id}, _resolution) do
    Caffe.Menu.delete_item(id)
  end
end
