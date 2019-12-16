defmodule Caffe.SeedsTest do
  use Caffe.DataCase, async: true

  alias Caffe.Seeds
  alias Caffe.{Repo, Menu}

  describe "run" do
    test "categories should be idempotent" do
      assert_idempotent(Menu.Category)
    end

    test "items should be idempotent" do
      assert_idempotent(Menu.Item)
    end

    def assert_idempotent(module) do
      Seeds.run()
      count = module |> Repo.all() |> length
      assert count > 0

      Seeds.run()
      assert module |> Repo.all() |> length == count
    end
  end
end
