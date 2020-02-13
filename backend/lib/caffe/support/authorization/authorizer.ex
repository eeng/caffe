defmodule Caffe.Authorization.Authorizer do
  @type use_case :: Caffe.Mediator.UseCase.use_case()

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
end
