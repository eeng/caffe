defmodule Caffe.Orders.Projections.TabItem do
  use Caffe.Schema
  alias Caffe.Orders.Projections.Tab

  @primary_key false

  schema "tabs_items" do
    belongs_to :tab, Tab
    field :menu_item_name, :string
    field :status, :string
    field :notes, :string
    field :price, :integer
    field :quantity, :integer
    timestamps()
  end
end
