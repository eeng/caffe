defmodule Caffe.Orders.Commands.OpenTab do
  defstruct [:tab_id, :table_number]
  # TODO waiter?

  use Caffe.Command
  alias __MODULE__
  alias Caffe.Orders.Projections.Tab
  alias Caffe.Repo

  validates :tab_id, uuid: true

  validates :table_number,
    number: true,
    by: [
      function: &OpenTab.validate_not_already_opened/2,
      message: "table already has an open tab"
    ]

  def validate_not_already_opened(nil, _command), do: true

  # TODO don't like doing persistance stuff here (on the domain). Also requires a DataCase on the tests
  def validate_not_already_opened(table_number, _command) do
    case Repo.get_by(Tab, table_number: table_number) do
      nil -> true
      %Tab{status: "closed"} -> true
      _ -> false
    end
  end
end
