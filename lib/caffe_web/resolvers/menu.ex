defmodule CaffeWeb.Resolvers.Menu do
  def list_items(_parent, _args, _resolution) do
    {:ok, Caffe.Menu.list_items()}
  end

  def list_categories(_parent, _args, _resolution) do
    {:ok, Caffe.Menu.list_categories()}
  end

  def create_item(_parent, %{input: params}, _resolution) do
    case Caffe.Menu.create_item(params) do
      {:ok, _} = success ->
        success

      {:error, changeset} ->
        {:error, message: "Could not create menu item", details: error_details(changeset)}
    end
  end

  def delete_item(_parent, %{id: id}, _resolution) do
    case Caffe.Menu.delete_item(id) do
      {:ok, _} -> {:ok, true}
      {:error, _} -> {:error, "Menu item not found"}
    end
  end

  defp error_details(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)
  end
end
