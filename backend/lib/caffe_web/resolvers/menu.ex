defmodule CaffeWeb.Resolvers.Menu do
  alias Caffe.Menu

  def list_items(_parent, _params, _resolution) do
    {:ok, Menu.list_items()}
  end

  def find_item(_parent, %{id: id}, _resolution) do
    Menu.get_item(id)
  end

  def list_categories(_parent, _params, _resolution) do
    {:ok, Menu.list_categories()}
  end

  def create_item(_parent, params, %{context: %{current_user: user}}) do
    Menu.create_item(params, user)
  end

  def update_item(_parent, params, %{context: %{current_user: user}}) do
    Menu.update_item(params, user)
  end

  def delete_item(_parent, %{id: id}, %{context: %{current_user: user}}) do
    Menu.delete_item(id, user)
  end

  def image_url(menu_item, _params, _resolution) do
    with "/priv" <> public_path <- Menu.Image.url({menu_item.image, menu_item}) do
      {:ok, CaffeWeb.Endpoint.url() <> public_path}
    else
      _ -> {:ok, nil}
    end
  end
end
