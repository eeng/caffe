defmodule Caffe.Schema do
  @moduledoc """
  Like Ecto.Schema but with UUID defaults.
  """

  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      @primary_key {:id, :binary_id, autogenerate: false}
      @foreign_key_type :binary_id
    end
  end
end
