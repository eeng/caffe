import React from "react";
import { factory, render } from "/__test__/testHelper";
import KitchenPage, { KITCHEN_ORDERS_QUERY } from "./KitchenPage";
import { BEGIN_PREPARATION_MUTATION } from "./BeginPreparationButton";

test("preparing some orders in the kitchen", async () => {
  const mockQuery = (itemState: string) =>
    factory.mockQuery(KITCHEN_ORDERS_QUERY).returnsData({
      kitchenOrders: [
        {
          id: "1",
          code: "A12B",
          items: [
            {
              menuItemId: "1",
              menuItemName: "Fish",
              quantity: 1,
              state: itemState
            }
          ]
        }
      ]
    });

  const mockMutation = factory
    .mockQuery(BEGIN_PREPARATION_MUTATION, {
      variables: { orderId: "1", itemIds: ["1"] }
    })
    .returnsData({ beginFoodPreparation: "ok" });

  const r = render(<KitchenPage />, {
    mocks: [mockQuery("pending"), mockMutation, mockQuery("preparing")]
  });

  await r.findByText("Kitchen", { selector: ".PageTitle" });

  await r.findByText("Order A12B");
  r.getByText("Begin Preparation").click();
  await r.findByText("Preparing");
});
