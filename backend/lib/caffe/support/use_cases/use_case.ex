defmodule Caffe.Mediator.UseCase do
  @type use_case :: struct
  @type result :: {:ok, term} | {:error, term}

  @callback init(use_case) :: {:ok, use_case} | {:error, term}
  @callback authorize(use_case) :: boolean
  @callback execute(use_case) :: result

  defmacro __using__(_) do
    quote do
      @behaviour unquote(__MODULE__)

      alias __MODULE__
      alias Caffe.{Repo, Router}
      import Ecto.Query

      @before_compile unquote(__MODULE__)

      def init(use_case), do: {:ok, use_case}
      defoverridable init: 1

      def wrap_ok_result(:ok), do: {:ok, "ok"}
      def wrap_ok_result(result), do: result
    end
  end

  # Injects a default authorize implementation at the end of the module using this
  # to force it to explicit authorize all use cases.
  defmacro __before_compile__(_env) do
    quote do
      def authorize(use_case), do: false
    end
  end
end
