import React from "react";
import { render, factory } from "../__test__/testHelper";
import DashboardPage, { STATS_QUERY } from "./DashboardPage";

test("should display the order stats", async () => {
  const mockQuery = factory
    .mockQuery(STATS_QUERY, {
      variables: { since: "2020-01-05T00:00:00.000Z" }
    })
    .returnsData({
      stats: { orderCount: 5, amountEarned: "7.5", tipEarned: "2" }
    });

  const r = render(<DashboardPage now={new Date("2020-01-05")} />, {
    mocks: [mockQuery]
  });
  await r.findByText("Orders Placed");
  expect(r.getByText("$7.50")).toBeInTheDocument();
  expect(r.getByTestId("ordersPlaced")).toHaveTextContent("5");
  expect(r.getByTestId("amountEarned")).toHaveTextContent("$7.50");
});
