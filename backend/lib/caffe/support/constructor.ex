defmodule Caffe.Constructor do
  @moduledoc """
  Like ExConstructor but lightweight, since we don't need to handle different type of arguments.
  """

  defmacro __using__(_) do
    quote do
      def new(args \\ %{}) do
        struct(__MODULE__, args)
      end

      defoverridable new: 0, new: 1
    end
  end
end
