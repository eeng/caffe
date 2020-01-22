defmodule Caffe.AggregateCase do
  @moduledoc """
  This module defines the test case to be used by aggregate tests.
  """

  use ExUnit.CaseTemplate, async: true

  using aggregate: aggregate do
    quote bind_quoted: [aggregate: aggregate] do
      @aggregate_module aggregate

      def assert_result(commands, expected_result) do
        assert_result([], commands, expected_result)
      end

      def assert_result(initial_events, commands, expected_result) do
        {_aggregate, events_or_error} =
          %@aggregate_module{}
          |> evolve(initial_events)
          |> execute(commands)

        assert expected_result == events_or_error
      end

      @doc """
      Execute one o more commands against an aggregate.
      Returns a tuple with the new aggregate and the events or error produced.
      """
      def execute(aggregate, commands) do
        commands
        |> List.wrap()
        |> Enum.reduce({aggregate, nil}, fn
          _command, {_aggregate, {:error, _}} = reply ->
            reply

          command, {aggregate, _} ->
            case @aggregate_module.execute(aggregate, command) do
              {:error, reason} = error -> {aggregate, error}
              events -> {evolve(aggregate, events), events}
            end
        end)
      end

      # Apply the given events to the aggregate state
      defp evolve(aggregate, events) do
        events
        |> List.wrap()
        |> Enum.reduce(aggregate, &@aggregate_module.apply(&2, &1))
      end
    end
  end
end
