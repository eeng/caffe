defmodule Caffe.Ordering.Projections.Activity do
  use Ecto.Schema

  alias Caffe.Accounts.User

  schema "activities" do
    field :type, :string
    field :published, :utc_datetime
    belongs_to :actor, User
    field :object_type, :string
    field :object_id, :string
  end
end
