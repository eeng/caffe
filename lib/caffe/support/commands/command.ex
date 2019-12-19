defmodule Caffe.Command do
  defmacro __using__(_) do
    quote do
      use Caffe.Constructor
      use Ecto.Schema
      import Ecto.Changeset
      import Ecto.Query

      @primary_key false
    end
  end
end
