defmodule Caffe.Middleware.Validator do
  @behaviour Commanded.Middleware

  alias Commanded.Middleware.Pipeline
  import Pipeline

  def before_dispatch(%Pipeline{command: command} = pipeline) do
    if Vex.valid?(command) do
      pipeline
    else
      handle_validation_failure(pipeline)
    end
  end

  def after_dispatch(%Pipeline{} = pipeline) do
    pipeline
  end

  def after_failure(%Pipeline{} = pipeline) do
    pipeline
  end

  defp handle_validation_failure(%Pipeline{command: command} = pipeline) do
    errors = command |> Vex.errors() |> merge_errors()

    pipeline
    |> respond({:error, :validation_failure, errors})
    |> halt()
  end

  def merge_errors(errors) do
    Enum.group_by(
      errors,
      fn {_, field, _, _message} -> field end,
      fn {_, _field, _, message} -> message end
    )
  end
end
