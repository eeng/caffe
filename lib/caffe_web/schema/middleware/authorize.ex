defmodule CaffeWeb.Schema.Middleware.Authorize do
  @behaviour Absinthe.Middleware
  @dialyzer :no_undefined_callbacks

  def call(resolution, opts) do
    with %{current_user: current_user} <- resolution.context,
         true <- authorized?(current_user, opts) do
      resolution
    else
      _ -> resolution |> Absinthe.Resolution.put_result({:error, "unauthorized"})
    end
  end

  defp authorized?(%{role: role}, role), do: true
  defp authorized?(%{}, :any), do: true
  defp authorized?(_, _), do: false
end
