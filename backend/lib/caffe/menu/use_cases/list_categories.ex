defmodule Caffe.Menu.UseCases.ListCategories do
  use Caffe.Mediator.UseCase
  import Ecto.Query
  alias Caffe.Menu.Category

  defstruct []

  @impl true
  def execute(%ListCategories{}) do
    categories = Category |> order_by(asc: :position) |> Repo.all()
    {:ok, categories}
  end

  @impl true
  def authorize(%ListCategories{}), do: true
end
