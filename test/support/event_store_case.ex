defmodule Caffe.EventStoreCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Caffe.DataCase

      import Commanded.Assertions.EventAssertions
    end
  end

  setup do
    on_exit(fn ->
      :ok = Application.stop(:caffe)
      :ok = Application.stop(:commanded)

      {:ok, _apps} = Application.ensure_all_started(:caffe)
    end)
  end
end
