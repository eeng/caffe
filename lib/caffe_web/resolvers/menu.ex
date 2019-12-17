defmodule CaffeWeb.Resolvers.Menu do
  def list_items(_parent, _args, _resolution) do
    {:ok, Caffe.Menu.list_items()}
  end

  def list_categories(_parent, _args, _resolution) do
    {:ok, Caffe.Menu.list_categories()}
  end

  def save_item(_parent, %{input: params}, _resolution) do
    case Caffe.Menu.save_item(params) do
      {:ok, _} = success ->
        success

      {:error, :not_found} ->
        {:error, message: "Menu item not found"}

      {:error, changeset} ->
        {:error, message: "Could not save menu item", details: error_details(changeset)}
    end
  end

  def delete_item(_parent, %{id: id}, _resolution) do
    case Caffe.Menu.delete_item(id) do
      {:ok, _} -> {:ok, true}
      {:error, _} -> {:error, "Menu item not found"}
    end
  end

  defp error_details(%Ecto.Changeset{} = changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)
  end
end
