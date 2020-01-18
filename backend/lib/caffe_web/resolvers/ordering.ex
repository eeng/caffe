defmodule CaffeWeb.Resolvers.Ordering do
  alias Caffe.Ordering

  def place_order(_parent, params, %{context: %{current_user: user}}) do
    Ordering.place_order(params, user)
  end

  def mark_items_served(_parent, params, %{context: %{current_user: user}}) do
    Ordering.mark_items_served(params, user) |> ok_result
  end

  def begin_food_preparation(_parent, params, %{context: %{current_user: user}}) do
    Ordering.begin_food_preparation(params, user) |> ok_result
  end

  def mark_food_prepared(_parent, params, %{context: %{current_user: user}}) do
    Ordering.mark_food_prepared(params, user) |> ok_result
  end

  def pay_order(_parent, params, %{context: %{current_user: user}}) do
    Ordering.pay_order(params, user) |> ok_result
  end

  def cancel_order(_parent, params, %{context: %{current_user: user}}) do
    Ordering.cancel_order(params, user) |> ok_result
  end

  def get_order(_parent, %{id: id}, _resolution) do
    case Ordering.get_order(id) do
      nil -> {:error, :not_found}
      order -> {:ok, order}
    end
  end

  def list_orders(_parent, params, %{context: %{current_user: user}}) do
    {:ok, Ordering.list_orders(user, params)}
  end

  def get_stats(_parent, params, _resolution) do
    {:ok, Ordering.get_stats(params)}
  end

  defp ok_result(result) do
    with :ok <- result do
      {:ok, "ok"}
    end
  end
end
