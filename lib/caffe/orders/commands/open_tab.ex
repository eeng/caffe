defmodule Caffe.Orders.Commands.OpenTab do
  defstruct [:tab_id, :table_number]
  # TODO waiter?

  use Caffe.Command
  alias __MODULE__
  alias Caffe.Orders.Projections.Tab
  alias Caffe.Repo
  import Ecto.Query

  validates :tab_id, uuid: true

  validates :table_number,
    number: true,
    by: [
      function: &OpenTab.validate_not_already_opened/2,
      message: "table already has an open tab"
    ]

  def validate_not_already_opened(nil, _command), do: true

  def validate_not_already_opened(table_number, _command) do
    # TODO use an enum?
    opened_tabs_count =
      Repo.one(from Tab, where: [table_number: ^table_number, status: "opened"], select: count())

    opened_tabs_count == 0
  end
end
