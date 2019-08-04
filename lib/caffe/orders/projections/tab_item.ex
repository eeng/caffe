defmodule Caffe.Orders.Projections.TabItem do
  use Caffe.Schema
  import Ecto.Changeset
  alias Caffe.Orders.Projections.Tab

  defmodule Status do
    use Exnumerator, values: ["pending", "preparing", "prepared", "served"]
  end

  @primary_key false

  schema "tab_items" do
    belongs_to :tab, Tab
    field :menu_item_id, :integer
    field :menu_item_name, :string
    field :status, Status, default: "pending"
    field :notes, :string
    field :price, :decimal
    field :quantity, :integer
    timestamps()
  end

  def changeset(item, params) do
    item
    |> cast(params, [:menu_item_id, :menu_item_name, :price, :quantity, :notes, :status])
    |> validate_required([:menu_item_id, :menu_item_name, :price, :quantity])
    |> foreign_key_constraint(:tab_id)
  end
end
