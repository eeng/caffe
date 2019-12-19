defmodule Caffe.Middleware.Validator do
  @behaviour Commanded.Middleware

  alias Commanded.Middleware.Pipeline
  import Pipeline

  def before_dispatch(%Pipeline{command: command} = pipeline) do
    changeset = build_changeset(command)

    case Ecto.Changeset.apply_action(changeset, :insert) do
      {:ok, command} ->
        # Replace the command as the new one may have fields casted, defaults assigned, etc.
        pipeline |> Map.put(:command, command)

      {:error, changeset} ->
        pipeline
        |> respond({:error, :validation_failure, transform_errors(changeset)})
        |> halt()
    end
  end

  def after_dispatch(%Pipeline{} = pipeline) do
    pipeline
  end

  def after_failure(%Pipeline{} = pipeline) do
    pipeline
  end

  # All commands must implement a changeset/2 function for this to work
  defp build_changeset(command) do
    command.__struct__.changeset(struct(command.__struct__), Map.from_struct(command))
  end

  defp transform_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
