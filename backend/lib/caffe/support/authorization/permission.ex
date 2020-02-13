defmodule Caffe.Authorization.Permission do
  @moduledoc """
  This module translates the use cases' long names to simple atoms that can be used
  in the frontend, so we have less coupling between the two.
  """

  alias Caffe.Authorization.Authorizer
  alias Caffe.{Accounts, Menu, Ordering}

  @use_cases_by_permission %{
    create_user: Accounts.UseCases.CreateUser,
    list_users: Accounts.UseCases.ListUsers,
    create_menu_item: Menu.UseCases.CreateItem,
    update_menu_item: Menu.UseCases.UpdateItem,
    delete_menu_item: Menu.UseCases.DeleteItem,
    place_order: Ordering.UseCases.PlaceOrder,
    cancel_order: Ordering.UseCases.CancelOrder,
    mark_items_served: Ordering.UseCases.MarkItemsServed,
    begin_food_preparation: Ordering.UseCases.BeginFoodPreparation,
    mark_food_prepared: Ordering.UseCases.MarkFoodPrepared,
    pay_order: Ordering.UseCases.PayOrder,
    list_orders: Ordering.UseCases.ListOrders,
    list_kitchen_orders: Ordering.UseCases.GetKitchenOrders,
    list_waitstaff_orders: Ordering.UseCases.GetWaitstaffOrders,
    get_activity_feed: Ordering.UseCases.GetActivityFeed,
    get_stats: Ordering.UseCases.CalculateStats,
    serve_item: Ordering.UseCases.ServeItem
  }

  def available_for(user) do
    @use_cases_by_permission |> Map.keys() |> Enum.filter(&can?(user, &1))
  end

  def can?(user, permission, resource \\ nil) do
    use_case_mod = Map.fetch!(@use_cases_by_permission, permission)
    Authorizer.authorize?(struct(use_case_mod, user: user, resource: resource))
  end
end
