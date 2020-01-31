import React from "react";
import { MemoryRouter } from "react-router-dom";
import { MENU_QUERY } from "./PlaceOrderForm";
import PlaceOrderPage from "./PlaceOrderPage";
import { factory, render } from "/__test__/testHelper";
import { PLACE_ORDER_MUTATION } from "./PlaceOrderSummary";

test("placing an order", async () => {
  const item1 = factory.orderMenuItem({ name: "Burger", price: 5 });
  const item2 = factory.orderMenuItem({ name: "Lomito", price: 6 });

  const mockMenuQuery = factory.mockQuery(MENU_QUERY).returnsData({
    categories: [
      {
        name: "Sandwiches",
        position: 1,
        items: [item1, item2]
      }
    ]
  });

  const mockMutation = factory
    .mockQuery(PLACE_ORDER_MUTATION, {
      variables: {
        items: [
          { menuItemId: item1.id, quantity: 2 },
          { menuItemId: item2.id, quantity: 1 }
        ],
        notes: ""
      }
    })
    .returnsData({ placeOrder: { id: "12345" } });

  const r = render(
    <MemoryRouter initialEntries={["/place_order"]}>
      <PlaceOrderPage />
    </MemoryRouter>,
    { mocks: [mockMenuQuery, mockMutation] }
  );

  expect(r.getByText("Place Order", { selector: ".PageTitle" }));
  await r.findByText("Sandwiches");
  expect(r.queryByText("Review Order")).toBeNull();
  expect(r.queryAllByText("Add")).toHaveLength(2);
  r.queryAllByText("Add")[0].click();
  r.queryAllByText("Add")[0].click();
  r.queryAllByText("Add")[1].click();
  r.getByText("Review Order").click();

  expect(r.getByText("Order Summary", { selector: ".PageTitle" }));
  expect(r.getByText("$16.00", { selector: ".total-amount" }));
  r.getByText("Confirm Order").click();

  await r.findByText("Order Placed", { selector: ".PageTitle" });
  expect(r.getByText("View Order Status").getAttribute("href")).toBe(
    "/orders/12345"
  );
});
