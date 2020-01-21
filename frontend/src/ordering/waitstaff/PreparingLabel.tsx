import React from "react";
import { Icon, Label } from "semantic-ui-react";
import { OrderItem } from "../model";

function PreparingLabel({ item }: { item: OrderItem }) {
  if (item.state != "preparing") return null;

  return (
    <Label>
      <Icon name="spinner" loading />
      Preparing
    </Label>
  );
}

export default PreparingLabel;
