defmodule Caffe.Repo.Migrations.AddMenuItemsImage do
  use Ecto.Migration

  def change do
    alter table(:menu_items) do
      add :image, :string
    end
  end
end
