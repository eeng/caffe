defmodule Caffe.Menu.Image do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original]

  def storage_dir(_version, {_file, scope}) do
    "priv/uploads/menu/items/#{scope.id}"
  end
end
