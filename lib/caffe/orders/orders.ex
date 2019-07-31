defmodule Caffe.Orders do
  @moduledoc """
  The Orders bounded context boundary.
  """

  alias Caffe.Router
  alias Caffe.Orders.Commands.OpenTab

  def open_tab(args) do
    id = UUID.uuid4()
    command = struct(OpenTab, Map.put(args, :tab_id, id))

    case Router.dispatch(command, consistency: :strong) do
      :ok -> {:ok, id}
      reply -> reply
    end
  end
end

"""
Orders.open_tab(%{table_number: 5})
"""
