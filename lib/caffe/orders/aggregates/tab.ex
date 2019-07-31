defmodule Caffe.Orders.Aggregates.Tab do
  defstruct [:id, :table_number]

  use Caffe.Orders.Aliases

  def execute(%Tab{id: nil}, %OpenTab{} = command) do
    struct(TabOpened, Map.from_struct(command))
  end

  def execute(%Tab{}, %OpenTab{}), do: {:error, :tab_already_opened}

  def apply(%Tab{}, %TabOpened{tab_id: id}) do
    %Tab{id: id}
  end
end
