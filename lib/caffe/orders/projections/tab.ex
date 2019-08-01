defmodule Caffe.Orders.Projection.Tab do
  use Caffe.Schema
  alias Caffe.Orders.Projection.TabItem

  schema "tabs" do
    field :table_number, :integer
    has_many :items, TabItem
    timestamps()
  end
end
