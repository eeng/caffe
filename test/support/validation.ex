defmodule Caffe.Support.Validation do
  def errors_on(module, params) do
    errors_on(module.changeset(struct(module), params))
  end

  def errors_on(changeset) do
    Caffe.Middleware.Validator.transform_errors(changeset)
  end

  def error_fields_on(module, params) do
    errors_on(module, params) |> Map.keys()
  end
end
