defmodule CaffeWeb.Schema.Middleware.ChangesetErrors do
  @behaviour Absinthe.Middleware
  @dialyzer :no_undefined_callbacks

  def call(resolution, _) do
    %{resolution | errors: Enum.map(resolution.errors, &transform_error/1)}
  end

  defp transform_error(%Ecto.Changeset{} = changeset) do
    [
      message: "validation_error",
      details: Caffe.Middleware.Validator.transform_errors(changeset)
    ]
  end

  defp transform_error(error), do: error
end
