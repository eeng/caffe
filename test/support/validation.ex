defmodule Caffe.Support.Validation do
  def errors_on(module, params) do
    errors_on(module.changeset(struct(module), params))
  end

  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  def error_fields_on(module, params) do
    errors_on(module, params) |> Map.keys()
  end
end
