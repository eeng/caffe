import { gql, useMutation } from "@apollo/client";
import React from "react";
import { toast } from "react-semantic-toasts";
import { Button } from "semantic-ui-react";
import { OrderDetails, OrderItem } from "../model";
import { isServerError } from "/lib/errors";

const MARK_AS_SERVED_MUTATION = gql`
  mutation($orderId: ID!, $itemIds: [ID!]) {
    markItemsServed(orderId: $orderId, itemIds: $itemIds)
  }
`;

function MarkAsServedButton({
  item,
  order
}: {
  item: OrderItem;
  order: OrderDetails;
}) {
  if (!item.viewerCanServe) return null;

  const [markItemsServed, { loading }] = useMutation(MARK_AS_SERVED_MUTATION, {
    variables: { orderId: order.id, itemIds: [item.menuItemId] },
    refetchQueries: ["WaitstaffOrders"],
    awaitRefetchQueries: true
  });

  function handleClick() {
    markItemsServed()
      .then(() =>
        toast({
          title: "Perfect!",
          description: `The "${item.menuItemName}" was served.`,
          type: "success",
          time: 5000
        })
      )
      .catch(
        e =>
          isServerError("item_already_served", e) &&
          toast({
            title: "Command already processed",
            description: "This item has already been served.",
            type: "error"
          })
      );
  }

  return (
    <Button
      content="Mark as Served"
      primary
      onClick={handleClick}
      loading={loading}
      disabled={loading}
    />
  );
}

export default MarkAsServedButton;
