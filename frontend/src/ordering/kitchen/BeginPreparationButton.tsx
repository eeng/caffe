import { gql, useMutation } from "@apollo/client";
import React from "react";
import { toast } from "react-semantic-toasts";
import { Button } from "semantic-ui-react";
import { OrderDetails, OrderItem } from "../model";

export const BEGIN_PREPARATION_MUTATION = gql`
  mutation($orderId: ID!, $itemIds: [ID!]) {
    beginFoodPreparation(orderId: $orderId, itemIds: $itemIds)
  }
`;

function BeginPreparationButton({
  item,
  order
}: {
  item: OrderItem;
  order: OrderDetails;
}) {
  if (item.state != "pending") return null;

  const [beginPreparation, { loading }] = useMutation(
    BEGIN_PREPARATION_MUTATION,
    {
      variables: { orderId: order.id, itemIds: [item.menuItemId] },
      refetchQueries: ["KitchenOrders"],
      awaitRefetchQueries: true
    }
  );

  function handleClick() {
    beginPreparation().then(() =>
      toast({
        title: "Well Done!",
        description: `You should prepare the "${item.menuItemName}" and then mark it as prepared.`,
        type: "success",
        time: 5000
      })
    );
  }

  return (
    <Button
      content="Begin Preparation"
      primary
      onClick={handleClick}
      loading={loading}
      disabled={loading}
    />
  );
}

export default BeginPreparationButton;
