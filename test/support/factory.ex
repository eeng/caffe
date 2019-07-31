defmodule Caffe.Factory do
  alias Caffe.Repo
  alias Caffe.Menus.MenuItem

  # Factories

  def build(:menu_item) do
    %MenuItem{id: uuid(), name: "Ham and Egg", category: "Breakfast", price: 10}
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end

  defp uuid do
    UUID.uuid4()
  end
end
