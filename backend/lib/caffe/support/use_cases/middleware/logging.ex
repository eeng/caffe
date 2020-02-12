defmodule Caffe.Mediator.Middleware.Logging do
  require Logger

  def build(next) do
    fn request ->
      Logger.info(fn -> "Dispatching #{inspect(request)}" end)

      started_at = DateTime.utc_now()
      result = next.(request)

      case result do
        {:error, reason} ->
          Logger.info(fn ->
            "#{log_context(request)} failed due to #{inspect(reason)}"
          end)

        _ ->
          Logger.info(fn ->
            "#{log_context(request)} succeded in #{formatted_diff(delta(started_at))}"
          end)
      end

      result
    end
  end

  defp delta(started_at) do
    DateTime.diff(DateTime.utc_now(), started_at, :microsecond)
  end

  defp log_context(request) do
    inspect(request.__struct__)
  end

  defp formatted_diff(diff) when diff > 1_000_000,
    do: [diff |> div(1_000_000) |> Integer.to_string(), "s"]

  defp formatted_diff(diff) when diff > 1_000,
    do: [diff |> div(1_000) |> Integer.to_string(), "ms"]

  defp formatted_diff(diff), do: [diff |> Integer.to_string(), "µs"]
end
