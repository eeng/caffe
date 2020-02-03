defmodule Caffe.Release do
  @app :caffe

  def migrate do
    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end

    init_event_store()
  end

  def rollback(repo, version) do
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.load(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp init_event_store do
    config = EventStore.Config.parsed(Caffe.EventStore, @app)

    # :ok = EventStore.Tasks.Create.exec(config, [])
    :ok = EventStore.Tasks.Init.exec(Caffe.EventStore, config, [])
  end

  def seed do
    Application.load(@app)
    Application.ensure_all_started(:arc)
    Ecto.Migrator.with_repo(Caffe.Repo, fn _ -> Caffe.Seeds.run() end)
  end
end
