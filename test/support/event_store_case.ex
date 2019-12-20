# TODO needed?
defmodule Caffe.EventStoreCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Caffe.DataCase

      import Commanded.Assertions.EventAssertions
    end
  end
end
