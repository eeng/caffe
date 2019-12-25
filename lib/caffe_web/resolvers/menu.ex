defmodule CaffeWeb.Resolvers.Menu do
  alias Caffe.Menu
  alias Caffe.Menu.AuthPolicy
  alias Caffe.Support.Authorizer

  def list_items(_parent, _args, _resolution) do
    {:ok, Menu.list_items()}
  end

  def list_categories(_parent, _args, _resolution) do
    {:ok, Menu.list_categories()}
  end

  def create_item(_parent, params, %{context: context}) do
    with :ok <- Authorizer.authorize(AuthPolicy, :create_menu_item, context[:current_user]) do
      Menu.create_item(params)
    end
  end

  def update_item(_parent, params, %{context: context}) do
    with :ok <- Authorizer.authorize(AuthPolicy, :update_menu_item, context[:current_user]) do
      Menu.update_item(params)
    end
  end

  def delete_item(_parent, %{id: id}, %{context: context}) do
    with :ok <- Authorizer.authorize(AuthPolicy, :delete_menu_item, context[:current_user]) do
      Menu.delete_item(id)
    end
  end
end
