import { gql, useMutation } from "@apollo/client";
import React from "react";
import { toast } from "react-semantic-toasts";
import { Button, ButtonProps } from "semantic-ui-react";
import { OrderDetails } from "./model";
import { MY_ORDERS_QUERY } from "./OrdersPage";
import Confirm from "/shared/Confirm";
import { GET_ORDER_QUERY } from "./OrderDetailsPage";

const CANCEL_ORDER_MUTATION = gql`
  mutation($orderId: ID) {
    cancelOrder(orderId: $orderId)
  }
`;

interface Props extends ButtonProps {
  order: OrderDetails;
}

function CancelOrderButton({ order, ...rest }: Props) {
  if (!order.viewerCanCancel) return null;

  const [cancelOrder, { loading }] = useMutation(CANCEL_ORDER_MUTATION, {
    variables: { orderId: order.id },
    refetchQueries: [
      { query: MY_ORDERS_QUERY },
      { query: GET_ORDER_QUERY, variables: { id: order.id } }
    ],
    awaitRefetchQueries: true
  });

  function handleConfirm() {
    cancelOrder()
      .then(() =>
        toast({
          title: "Done!",
          description: `The order ${order.code} has been cancelled.`,
          type: "success",
          time: 4000
        })
      )
      .catch(() =>
        toast({
          title: "Order is being prepared",
          description: "Sorry but the order can no longer be cancelled.",
          type: "error",
          time: 4000
        })
      );
  }

  return (
    <Confirm onConfirm={handleConfirm} disabled={loading}>
      <Button
        content="Cancel"
        color="red"
        disabled={loading}
        loading={loading}
        {...rest}
      />
    </Confirm>
  );
}

export default CancelOrderButton;
