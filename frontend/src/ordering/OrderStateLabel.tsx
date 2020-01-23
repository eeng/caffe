import React from "react";
import { Label, SemanticCOLORS } from "semantic-ui-react";
import { OrderDetails } from "./model";

const STATE_COLORS: Record<string, SemanticCOLORS> = {
  cancelled: "red",
  served: "purple",
  paid: "green"
};

function OrderStateLabel({ order }: { order: OrderDetails }) {
  return (
    <Label
      content={order.state.toUpperCase()}
      color={STATE_COLORS[order.state] || "grey"}
      size="small"
    />
  );
}

export default OrderStateLabel;
