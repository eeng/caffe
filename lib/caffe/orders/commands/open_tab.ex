defmodule Caffe.Orders.Commands.OpenTab do
  defstruct [:tab_id, :table_number]
  # TODO waiter?

  alias __MODULE__
  alias Caffe.Orders.Projections.Tab
  alias Caffe.Repo
  use Vex.Struct

  validates :tab_id, uuid: true

  validates :table_number,
    number: true,
    by: [
      function: &OpenTab.validate_not_already_opened/2,
      message: "table already has an open tab"
    ]

  def validate_not_already_opened(nil, _command), do: true

  def validate_not_already_opened(table_number, _command) do
    case Repo.get_by(Tab, table_number: table_number) do
      nil -> true
      # TODO why dont delete the tab (and its items) on closed? that way this is not needed (and maybe the status either)
      %Tab{status: "closed"} -> true
      _ -> false
    end
  end
end
