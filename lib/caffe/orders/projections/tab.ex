defmodule Caffe.Orders.Projections.Tab do
  use Caffe.Schema
  alias Caffe.Orders.Projections.TabItem

  schema "tabs" do
    field :table_number, :integer
    has_many :items, TabItem
    timestamps()
  end
end
