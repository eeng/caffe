defmodule Caffe.Authorization.Authorizer do
  @type use_case :: Caffe.Mediator.UseCase.use_case()

  @policies Application.get_env(:caffe, :authorization_policies, [])

  def authorize?(action, user, params \\ nil) do
    if policy = Enum.find(@policies, &(action in &1.actions)) do
      policy.authorize(action, user, params)
    else
      raise "Could not found a policy for action '#{action}'."
    end
  end

  def authorize(action, user, params \\ nil) do
    case authorize?(action, user, params) do
      true -> :ok
      false -> {:error, :unauthorized}
    end
  end

  @spec authorize?(use_case) :: boolean
  def authorize?(use_case) do
    use_case.__struct__.authorize(use_case)
  end

  def authorize(use_case) do
    case authorize?(use_case) do
      true -> :ok
      false -> {:error, :unauthorized}
    end
  end

  @available_use_cases [
    Caffe.Accounts.UseCases.CreateUser,
    Caffe.Accounts.UseCases.ListUsers,
    Caffe.Menu.UseCases.CreateItem,
    Caffe.Menu.UseCases.UpdateItem,
    Caffe.Menu.UseCases.DeleteItem,
    Caffe.Menu.UseCases.ListItems,
    Caffe.Menu.UseCases.GetItem,
    Caffe.Ordering.UseCases.PlaceOrder,
    Caffe.Ordering.UseCases.CancelOrder,
    Caffe.Ordering.UseCases.MarkItemsServed,
    Caffe.Ordering.UseCases.BeginFoodPreparation,
    Caffe.Ordering.UseCases.MarkFoodPrepared,
    Caffe.Ordering.UseCases.PayOrder,
    Caffe.Ordering.UseCases.GetOrder,
    Caffe.Ordering.UseCases.ListOrders,
    Caffe.Ordering.UseCases.GetKitchenOrders,
    Caffe.Ordering.UseCases.GetWaitstaffOrders,
    Caffe.Ordering.UseCases.GetActivityFeed,
    Caffe.Ordering.UseCases.CalculateStats
  ]

  def authorized_use_cases(user) do
    @available_use_cases
    |> Enum.filter(&(struct(&1, user: user) |> Map.has_key?(:user)))
    |> Enum.filter(&(struct(&1, user: user) |> authorize?))
    |> Enum.map(&(&1 |> to_string |> String.split(".") |> List.last() |> Macro.underscore()))
  end
end
