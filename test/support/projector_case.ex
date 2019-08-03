defmodule Caffe.ProjectorCase do
  use ExUnit.CaseTemplate

  using projector: projector do
    quote bind_quoted: [projector: projector] do
      @projector_module projector
      @projector_name @projector_module
                      |> to_string
                      |> String.replace("Elixir.Caffe.", "")

      use Caffe.DataCase

      alias Caffe.Repo
      import Caffe.Factory

      def handle_event(event) do
        event_number =
          @projector_name
          |> last_seen_event_number
          |> Kernel.+(1)

        @projector_module.handle(event, %{event_number: event_number})
      end

      def last_seen_event_number(name) do
        from(
          p in "projection_versions",
          where: p.projection_name == ^name,
          select: p.last_seen_event_number
        )
        |> Repo.one() || 0
      end

      def only_instance_of(mod) do
        mod |> Repo.one()
      end
    end
  end
end
