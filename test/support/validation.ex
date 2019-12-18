defmodule Caffe.Support.Validation do
  def errors_on(module, params) do
    errors_on(module.changeset(struct(module), params))
  end

  def errors_on(changeset) do
    Enum.map(changeset.errors, fn {field, {msg, opts}} ->
      {field, interpolate_message(msg, opts)}
    end)
  end

  defp interpolate_message(msg, opts) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
