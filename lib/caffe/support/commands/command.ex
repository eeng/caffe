defmodule Caffe.Command do
  defmacro __using__(_) do
    quote do
      use Vex.Struct
      use Caffe.Constructor
    end
  end
end
