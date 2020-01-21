import { gql, useMutation } from "@apollo/client";
import React from "react";
import { toast } from "react-semantic-toasts";
import { Button } from "semantic-ui-react";
import { OrderDetails, OrderItem } from "../model";

const MARK_AS_PREPARED_MUTATION = gql`
  mutation($orderId: ID!, $itemIds: [ID!]) {
    markFoodPrepared(orderId: $orderId, itemIds: $itemIds)
  }
`;

function MarkAsPreparedButton({
  item,
  order
}: {
  item: OrderItem;
  order: OrderDetails;
}) {
  if (item.state != "preparing") return null;

  const [markFoodPrepared, { loading }] = useMutation(
    MARK_AS_PREPARED_MUTATION,
    {
      variables: { orderId: order.id, itemIds: [item.menuItemId] },
      refetchQueries: ["KitchenOrders"],
      awaitRefetchQueries: true
    }
  );

  function handleClick() {
    markFoodPrepared().then(() =>
      toast({
        title: "Perfect!",
        description: `The "${item.menuItemName}" is ready to be served.`,
        type: "success",
        time: 5000
      })
    );
  }

  return (
    <Button
      content="Mark as Prepared"
      color="green"
      onClick={handleClick}
      loading={loading}
      disabled={loading}
    />
  );
}

export default MarkAsPreparedButton;
