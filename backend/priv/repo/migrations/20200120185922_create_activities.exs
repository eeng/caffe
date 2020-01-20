defmodule Caffe.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :type, :string
      add :published, :utc_datetime
      add :actor_id, references(:users)
      add :object_type, :string
      add :object_id, :string
    end

    create index(:activities, :published)
  end
end
