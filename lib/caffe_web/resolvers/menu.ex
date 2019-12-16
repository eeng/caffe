defmodule CaffeWeb.Resolvers.Menu do
  def list_items(_parent, _args, _resolution) do
    {:ok, Caffe.Menu.list_items()}
  end

  def list_categories(_parent, _args, _resolution) do
    {:ok, Caffe.Menu.list_categories()}
  end
end
